/**
 *
 */
package com.vango.testing.performance.viewer.data.services
{
    import flash.data.SQLConnection;
    import flash.data.SQLStatement;
    import flash.filesystem.File;

    import org.hamcrest.assertThat;
    import org.hamcrest.collection.array;
    import org.hamcrest.collection.arrayWithSize;
    import org.hamcrest.core.allOf;
    import org.hamcrest.object.hasProperties;
    import org.osflash.signals.Signal;
    import org.osflash.signals.utils.SignalAsyncEvent;
    import org.osflash.signals.utils.handleSignal;
    import org.osflash.signals.utils.proceedOnSignal;
    import org.osflash.signals.utils.registerFailureSignal;

    public class TestFileHistoryAdd
    {
        private var _historyService:FileHistoryService;
        private var _dbFile:File;
        private var _testingConnection:SQLConnection;

        private var successSignal:Signal = new Signal();
        private var failureSignal:Signal = new Signal();

        [Before(async)]
        public function setup():void
        {
            proceedOnSignal(this, successSignal, 100000);
            registerFailureSignal(this, failureSignal);

            _dbFile = File.createTempFile();
            _historyService = new FileHistoryService(_dbFile);
            _historyService.initialisationComplete.add(successSignal.dispatch);
            _historyService.initialisationFailed.add(failureSignal.dispatch);
            _historyService.initialise();
            _testingConnection = new SQLConnection();
            _testingConnection.open(_dbFile);
        }

        [After]
        public function after():void
        {
            _testingConnection.close();
            _historyService.destroy();
            _dbFile.moveToTrash();
        }

        [Test(async)]
        public function whenEntrySaved_givenRef_entryIsSavedSuccesfully():void
        {
            var ref:String = "testReferenceOne";
            var f:File = File.createTempFile();
            handleSignal(this, successSignal, onHistoryRetrieved, 100000);
            registerFailureSignal(this, failureSignal);
            _historyService.saveFileToHistory(successSignal.dispatch, f, ref);
            function onHistoryRetrieved(event:SignalAsyncEvent, data:Object):void
            {
                var result:Array = getAllEntries();
                assertThat(result, allOf(arrayWithSize(1), array(hasProperties({ref:ref, path:f.nativePath}))));
                f.deleteFile();
            }
        }

        [Test(expects=Error)]
        public function whenEntrySaved_givenNullRef_errorIsThrown():void
        {
            var f:File = File.createTempFile();
            _historyService.saveFileToHistory(successSignal.dispatch, f, null);
        }

        [Test(async)]
        public function whenMultipleEntriesSaved_givenSameRef_entriesAreSavedSuccesfully():void
        {
            var ref:String = "testReferenceOne";
            var files:Vector.<File> = Vector.<File>([File.createTempFile(), File.createTempFile()]);
            handleSignal(this, successSignal, onHistoryRetrieved, 100000);
            registerFailureSignal(this, failureSignal);
            _historyService.saveFilesToHistory(successSignal.dispatch, files, ref);
            function onHistoryRetrieved(event:SignalAsyncEvent, data:Object):void
            {
                var result:Array = getAllEntries();
                assertThat(result, allOf(arrayWithSize(2),array(
                        hasProperties({ref:ref, path:files[0].nativePath}),
                        hasProperties({ref:ref, path:files[1].nativePath}))));
            }
        }

        [Test(async)]
        public function whenMultipleEntriesSaved_givenDifferentRef_entriesAreSavedSuccesfully():void
        {
            var files:Vector.<File> = Vector.<File>([File.createTempFile(), File.createTempFile()]);
            var refs:Vector.<String> = Vector.<String>(["refOne", "refTwo"]);

            var current:int = 0;
            function commitNext():void
            {
                var callback:Function = current >= 1 ? successSignal.dispatch : commitNext;
                var f:File = files[current];
                var ref:String = refs[current];
                current++;
                _historyService.saveFileToHistory(callback, f, ref);
            }

            handleSignal(this, successSignal, onHistoryRetrieved, 100000);
            registerFailureSignal(this, failureSignal);
            commitNext();
            function onHistoryRetrieved(event:SignalAsyncEvent, data:Object):void
            {
                var result:Array = getAllEntries();
                assertThat(result, allOf(arrayWithSize(2),array(
                        hasProperties({ref:refs[0], path:files[0].nativePath}),
                        hasProperties({ref:refs[1], path:files[1].nativePath}))));

                result = getEntriesByRef(refs[0]);
                assertThat(result, allOf(arrayWithSize(1),array(
                        hasProperties({ref:refs[0], path:files[0].nativePath}))));

                result = getEntriesByRef(refs[1]);
                assertThat(result, allOf(arrayWithSize(1),array(
                        hasProperties({ref:refs[1], path:files[1].nativePath}))));
            }
        }

        private function getAllEntries():Array
        {
            var query:SQLStatement = new SQLStatement();
            query.sqlConnection = _testingConnection;
            query.text = "SELECT * FROM FileEntry";
            query.execute();
            return query.getResult().data;
        }

        private function getEntriesByRef(ref:String):Array
        {
            var query:SQLStatement = new SQLStatement();
            query.sqlConnection = _testingConnection;
            query.text = "SELECT * FROM FileEntry WHERE ref='" + ref + "'";
            query.execute();
            return query.getResult().data;
        }
    }
}
