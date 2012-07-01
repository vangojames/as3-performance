/**
 *
 */
package com.vango.testing.performance.viewer.run.services.retrieval
{
    import com.vango.testing.performance.viewer.controls.signals.UpdateStatusSignal;

    import flash.events.FileListEvent;
    import flash.filesystem.File;
    import flash.utils.getTimer;

    import org.robotlegs.mvcs.Actor;

    public class FileRetrievalService extends Actor
    {
        [Inject]
        public var updateStatusSignal:UpdateStatusSignal;

        public function get isProcessing():Boolean
        {
            return _isProcessing;
        }
        private var _isProcessing:Boolean;

        private var _ignoredDirectoryNames:Vector.<String> = Vector.<String>([".svn", ".git"]);
        private var _searchRoot:File;
        private var _currentFile:File;
        private var _processingQueue:Vector.<File> = new Vector.<File>();
        private var _output:Vector.<File>;
        private var _filter:Function;
        private var _onComplete:Function;
        private var _processingStartTime:int;
        private var _targetFrameRate:int = 24;
        private var _threshold:int = 1000 / _targetFrameRate;

        /**
         * Retrieves the complete list of files including the
         * @param root
         * @param output
         * @param onComplete
         * @param filter
         */
        public function retrieveAllFiles(root:File, onComplete:Function, filter:Function):void
        {
            if(_isProcessing)
            {
                throw new Error("Already processing, call stopProcessing before retrieving files");
            }

            _processingStartTime = getTimer();
            trace("Retrieving files from '" + root.nativePath + "'");
            _processingQueue = new Vector.<File>();

            this._filter = filter;
            this._searchRoot = root;
            this._output = new Vector.<File>();
            this._onComplete = onComplete;

            // process the root file
            processFile(root, _output, _filter);

            // now process the directory in the queue
            retrieveNextDirectoryListing();
        }

        /**
         * Stops any current processing
         */
        public function stopProcessing():void
        {
            if(!isProcessing)
            {
                throw new Error("Files are not being processed");
            }

            var dt:int = getTimer() - _processingStartTime;
            trace("Stopped retrieving files from '" + _currentFile.nativePath + "' after " + dt + "ms");
            _currentFile.removeEventListener(FileListEvent.DIRECTORY_LISTING, onDirectoriesRetrieved);
            _currentFile.cancel();
            _currentFile = null;
            _processingQueue = null;
            _filter = null;
            _onComplete = null;
            _output = null;
            _isProcessing = false;
        }

        /**
         * Processes the next file in the queue
         */
        private function retrieveNextDirectoryListing():void
        {
            var isComplete:Boolean = _processingQueue.length == 0;
            if(!isComplete)
            {
                // process as many synchronously before timer is exceeded
                _isProcessing = true;

                var startTime:int = getTimer();
                while(getTimer() - startTime < _threshold && _processingQueue.length > 0)
                {
                    _currentFile = _processingQueue.pop();
                    updateStatusSignal.dispatch("Processing directory '" + _currentFile.nativePath + "'");
                    // get files synchronously and process them
                    var files:Array = _currentFile.getDirectoryListing();
                    processEntireDirectory(files);
                }
                // now check if there are any left to process and process the next one asynchronously
                isComplete = _processingQueue.length == 0;
                if(!isComplete)
                {
                    _currentFile = _processingQueue.pop();
                    updateStatusSignal.dispatch("Processing directory '" + _currentFile.nativePath + "'");
                    // run an async call
                    _currentFile.addEventListener(FileListEvent.DIRECTORY_LISTING, onDirectoriesRetrieved);
                    _currentFile.getDirectoryListingAsync();
                }
            }

            // if the listings were all retrieved then this has completed
            if(isComplete)
            {
                _isProcessing = false;
                updateStatusSignal.dispatch("Processing complete");
                var dt:int = getTimer() - _processingStartTime;
                trace("Processed " + _output.length + " files in " + dt + "ms");
                _onComplete(_output);
            }
        }

        /**
         * Handles processing completed for a file
         */
        private function onDirectoriesRetrieved(event:FileListEvent):void
        {
            _currentFile.removeEventListener(FileListEvent.DIRECTORY_LISTING, onDirectoriesRetrieved);
            _currentFile = null;
            // process the directory
            processEntireDirectory(event.files);
            // now process the next list of files
            retrieveNextDirectoryListing();
        }

        /**
         * Processes an entire directory of files
         * @param fileList
         */
        private function processEntireDirectory(fileList:Array):void
        {
            for each(var f:File in fileList)
            {
                processFile(f, _output, _filter);
            }
        }

        /*
         * Processes a file to add to either the output or the processing queue
         */
        private function processFile(root:File, output:Vector.<File>, filter:Function):void
        {
            if(root.isDirectory)
            {
                if(_ignoredDirectoryNames.indexOf(root.name) >= 0)
                {
                    updateStatusSignal.dispatch("Ignoring '" + root.name + "' directory at '" + root.nativePath + "'");
                }
                else
                {
                    _processingQueue.push(root);
                }
            }
            else
            {
                var filterResult:Boolean = filter == null ? true : filter(root);
                if(filterResult == true)
                {
                    output.push(root);
                }
            }
        }
    }
}
