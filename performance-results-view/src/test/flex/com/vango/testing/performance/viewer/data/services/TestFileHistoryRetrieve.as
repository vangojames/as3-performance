/**
 *
 */
package com.vango.testing.performance.viewer.data.services
{
    import com.vango.testing.performance.viewer.data.vo.FileEntry;

    import flash.data.SQLConnection;
    import flash.events.IOErrorEvent;
    import flash.filesystem.File;
    import flash.utils.Dictionary;

    import org.hamcrest.assertThat;
    import org.hamcrest.collection.array;
    import org.hamcrest.collection.arrayWithSize;
    import org.hamcrest.collection.emptyArray;
    import org.hamcrest.core.allOf;
    import org.hamcrest.object.HasPropertiesMatcher;
    import org.osflash.signals.Signal;
    import org.osflash.signals.utils.SignalAsyncEvent;
    import org.osflash.signals.utils.failOnSignal;
    import org.osflash.signals.utils.handleSignal;
    import org.osflash.signals.utils.proceedOnSignal;
    import org.osflash.signals.utils.registerFailureSignal;

    [RunWith("org.flexunit.runners.Parameterized")]
    public class TestFileHistoryRetrieve
    {
        public static var refs:Array = [
            [{ref:REF_ONE, count:3}],
            [{ref:REF_TWO, count:3}]];
        public static var files:Dictionary = new Dictionary();

        private var _historyService:FileHistoryService;
        private var _dbFile:File;
        private var _testingConnection:SQLConnection;

        private var successSignal:Signal = new Signal();
        private var failureSignal:Signal = new Signal();

        private static const REF_ONE:String = "refOne";
        private static const REF_TWO:String = "refTwo";

        [BeforeClass]
        public static function createFiles():void
        {
            for each(var configList:Array in refs)
            {
                var config:Object = configList[0];
                var ref:String = config.ref;
                var count:int = config.count;
                var list:Vector.<File> = new Vector.<File>(count);
                files[ref] = list;
                for(var i:int = 0; i < count; i++)
                {
                    list[i] = File.createTempFile();
                }
            }
        }

        [AfterClass]
        public static function destroyFiles():void
        {
            for(var ref:String in files)
            {
                var list:Vector.<File> = files[ref];
                var count:int = list.length;
                for(var i:int = 0; i < count; i++)
                {
                    list[i].deleteFile();
                }
                list.length = 0;
            }
            files = null;
        }

        [Before(async)]
        public function setup():void
        {
            proceedOnSignal(this, successSignal, 100000);
            registerFailureSignal(this, failureSignal);

            _dbFile = File.createTempFile();
            _historyService = new FileHistoryService(_dbFile);
            _historyService.initialisationComplete.add(startupComplete);
            _historyService.initialisationFailed.add(failureSignal.dispatch);
            _historyService.initialise();
            _testingConnection = new SQLConnection();
            _testingConnection.open(_dbFile);
        }

        private function startupComplete():void
        {
            var currentSave:int = 0;
            saveNext();
            function saveNext():void
            {
                if(currentSave >= refs.length)
                {
                    successSignal.dispatch();
                }
                else
                {
                    var config:Object = refs[currentSave][0];
                    currentSave++;
                    var ref:String = config.ref;
                    var list:Vector.<File> = files[ref];
                    _historyService.saveFilesToHistory(saveNext, list, ref);
                }
            }
        }

        [After(async)]
        public function after():void
        {
            _testingConnection.close();
            _historyService.destroy();
            failOnSignal(this, failureSignal, 500);
            _dbFile.addEventListener(IOErrorEvent.IO_ERROR, onFileDeleteFailed, false, 0, true);
            _dbFile.deleteFileAsync();
        }

        private function onFileDeleteFailed(event:IOErrorEvent):void
        {
            failureSignal.dispatch();
        }

        [Test(async, dataProvider="refs")]
        public function whenEntriesRetrieved_givenRefExists_entriesAreReturned(config:Object):void
        {
            handleSignal(this, successSignal, onRetrieved, 500, config);
            _historyService.getFileHistory(successSignal.dispatch, config.ref);

            function onRetrieved(event:SignalAsyncEvent, refConfig:Object):void
            {
                var objects:Vector.<FileEntry> = event.args[0];
                var refFiles:Vector.<File> = files[refConfig.ref];
                var matchers:Array = [];
                for(var i:int = 0; i < refConfig.count; i++)
                {
                    matchers.push(new HasPropertiesMatcher({ref:refConfig.ref, path:refFiles[i].nativePath}));
                }
                assertThat(objects, allOf(arrayWithSize(refConfig.count), array.apply(undefined, matchers)));
            }
        }

        [Test(async)]
        public function whenEntriesRetrieved_givenRefDoesNotExist_emptyListReturned():void
        {
            handleSignal(this, successSignal, onRetrieved, 500, "testRef");
            _historyService.getFileHistory(successSignal.dispatch, "testRef");

            function onRetrieved(event:SignalAsyncEvent, refConfig:Object):void
            {
                var objects:Vector.<FileEntry> = event.args[0];
                assertThat(objects, emptyArray());
            }
        }

        [Test(async)]
        public function whenEntriesRetrieved_givenNullRef_allEntriesReturned():void
        {
            handleSignal(this, successSignal, onRetrieved, 500);
            _historyService.getFileHistory(successSignal.dispatch, null);

            function onRetrieved(event:SignalAsyncEvent, refConfig:Object):void
            {
                var objects:Vector.<FileEntry> = event.args[0];
                assertThat(objects, arrayWithSize(6));
            }
        }
    }
}
