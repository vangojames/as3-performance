/**
 *
 */
package com.vango.testing.performance.viewer.data.services
{
    import com.vango.testing.performance.viewer.data.vo.ClearFileHistoryRequest;
    import com.vango.testing.performance.viewer.data.vo.FileEntry;
    import com.vango.testing.performance.viewer.data.vo.HistoryRequest;
    import com.vango.testing.performance.viewer.data.vo.RetrieveFileHistoryRequest;
    import com.vango.testing.performance.viewer.data.vo.SaveFileHistoryRequest;

    import flash.errors.SQLError;
    import flash.filesystem.File;

    import org.osflash.signals.Signal;
    import org.osflash.spod.SpodDatabase;
    import org.osflash.spod.SpodManager;
    import org.osflash.spod.SpodObject;
    import org.osflash.spod.SpodTable;
    import org.osflash.spod.SpodTrigger;
    import org.osflash.spod.SpodTriggerDatabase;
    import org.osflash.spod.builders.expressions.order.DescOrderExpression;
    import org.osflash.spod.builders.expressions.where.EqualsToExpression;
    import org.osflash.spod.factories.SpodTriggerDatabaseFactory;

    public class FileHistoryService
    {
        /**
         * Determines whether the service is initialised or not
         */
        public function get isInitialised():Boolean
        {
            return _isInitialised;
        }
        private var _isInitialised:Boolean;

        /**
         * The path to the database file this service uses
         */
        public function get dbPath():String
        {
            return _dbPath;
        }
        private var _dbPath:String;

        public const initialisationComplete:Signal = new Signal();
        public const initialisationFailed:Signal = new Signal();

        private var _historyLimit:int;

        private var manager:SpodManager = new SpodManager(new SpodTriggerDatabaseFactory());
        private var fileEntryTable:SpodTable;

        private var _pendingQueue:Vector.<HistoryRequest> = new Vector.<HistoryRequest>();

        /**
         * Constructor
         */
        public function FileHistoryService(db:File = null, historyLimit:int = 50)
        {
            this._historyLimit = historyLimit;
            if(db == null)
            {
                _dbPath = File.applicationStorageDirectory.resolvePath("fileHistory.db").nativePath;
            }
            else
            {
                _dbPath = db.nativePath;
            }
        }

        /**
         * Initialises the service
         */
        public function initialise():void
        {
            if(isInitialised)
            {
                throw new Error("The service is already initialised. It cannot be initialised twice!");
            }

            // create the manager
            try
            {
                // open the connection
                manager.openSignal.addOnce(onOpen);
                manager.open(new File(dbPath));
            }
            catch (e:SQLError)
            {
                trace("Error connecting database : " + e.message);
                trace("Details : " + e.details);
                initialisationFailed.dispatch();
                return;
            }
        }

        /**
         * Executes a new request on the history service
         * @param request The request to execute
         */
        public function execute(request:HistoryRequest):void
        {
            if(!_isInitialised || _pendingQueue.length)
            {
                _pendingQueue.push(request);
            }
            else
            {
                _pendingQueue.push(request);
                nextRequest();
            }
        }

        /**
         * Destroys the service
         */
        public function destroy():void
        {
            manager.close();
        }

        /**
         * Handles db being opened
         */
        private function onOpen(database:SpodTriggerDatabase):void
        {
            trace("Created database at '" + dbPath + "'");
            // create new table for file entries
            database.createTableSignal.addOnce(onTableCreated);
            database.createTable(FileEntry, true);
        }

        /**
         * Fired when the table is created
         */
        private function onTableCreated(table:SpodTable):void
        {
            trace("Created table  : " + table);
            this.fileEntryTable = table;

            const database:SpodTriggerDatabase = SpodTriggerDatabase(table.manager.database);

            // create a trigger to limit the database size
            database.deleteTriggerSignal.addOnce(onTriggerRemoved).params = [database];
            database.deleteTrigger(FileEntry);
        }

        /**
         * Handles the trigger being removed
         */
        private function onTriggerRemoved(trigger:SpodTrigger, database:SpodTriggerDatabase):void
        {
            trace("Old trigger removed");
            database.createTriggerSignal.addOnce(onTriggerCreated).params = [database];
            database.createTrigger(FileEntry).after().insert().limit(_historyLimit, new DescOrderExpression('accessTime'));
            trigger;
        }

        /**
         * Handles trigger creation
         */
        private function onTriggerCreated(trigger:SpodTrigger, database:SpodTriggerDatabase):void
        {
            trace("Trigger created : " + trigger);
            //trace("Created trigger '" + trigger + "'");
            _isInitialised = true;
            initialisationComplete.dispatch();
            nextRequest();
        }

        /**
         * Fires the next request in the queue if there is one
         */
        private function nextRequest():void
        {
            if(_pendingQueue.length)
            {
                var request:HistoryRequest = _pendingQueue.shift();
                if(request is RetrieveFileHistoryRequest)
                {
                    getFileHistory(request as RetrieveFileHistoryRequest);
                }
                else if(request is SaveFileHistoryRequest)
                {
                    saveFileToHistory(request as SaveFileHistoryRequest);
                }
                else if(request is ClearFileHistoryRequest)
                {
                    clearHistory(request as ClearFileHistoryRequest);
                }
                else
                {
                    throw new Error("Unrecognised request type");
                }
            }
        }

        /**
         * Saves a file to the history
         */
        private function saveFileToHistory(request:SaveFileHistoryRequest):void
        {
            if(request.ref == null)
            {
                throw new Error("Cannot pass a null ref value");
            }
            // get the file entry to see if it exists
            var entry:FileEntry = new FileEntry();
            entry.accessTime = (new Date()).time;
            entry.ref = request.ref;
            entry.path = (request as SaveFileHistoryRequest).file.nativePath;
            fileEntryTable.insertSignal.addOnce(onSaved);
            fileEntryTable.insert(entry);

            function onSaved(item:FileEntry):void
            {
                request.callback(item);
                nextRequest();
            }
        }

        /**
         * Retrieves a file from the history
         */
        private function getFileHistory(request:RetrieveFileHistoryRequest):void
        {
            if(request.ref == null)
            {
                fileEntryTable.selectAllSignal.addOnce(onRetrieved);
                fileEntryTable.selectAll();
            }
            else
            {
                var refExpr:EqualsToExpression = new EqualsToExpression("ref", request.ref);
                fileEntryTable.selectWhereSignal.addOnce(onRetrieved);
                fileEntryTable.selectWhere(refExpr, new DescOrderExpression("accessTime"));
            }

            function onRetrieved(items:Vector.<SpodObject>):void
            {
                var history:Vector.<FileEntry> = new Vector.<FileEntry>(items.length);
                var l:int = items.length;
                for(var i:int = 0; i < l; i++)
                {
                    history[i] = items[i] as FileEntry;
                }
                request.callback(history);
                nextRequest();
            }
        }

        /**
         * Clears the history out
         */
        private function clearHistory(request:ClearFileHistoryRequest):void
        {
            var database:SpodDatabase = fileEntryTable.manager.database;

            if(request.ref == null)
            {
                database.deleteTableSignal.addOnce(onTableDeleted);
                database.deleteTable(FileEntry);

                function onTableDeleted():void
                {
                    fileEntryTable = null;
                    database.createTableSignal.addOnce(onNewTableCreated);
                    database.createTable(FileEntry);
                }
                function onNewTableCreated(table:SpodTable):void
                {
                    fileEntryTable = table;
                    request.callback();
                }
            }
            else
            {
                fileEntryTable.removeWhereSignal.addOnce(onRefsRemoved);
                fileEntryTable.removeWhere(new EqualsToExpression("ref", request.ref));

                function onRefsRemoved():void
                {
                    request.callback();
                }
            }
        }
    }
}
