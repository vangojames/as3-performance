/**
 *
 */
package com.vango.testing.performance.viewer.run.services
{
    import com.vango.testing.performance.viewer.controls.signals.UpdateStatusSignal;

    import flash.events.FileListEvent;
    import flash.filesystem.File;

    import mx.collections.ArrayCollection;

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

        private var _currentFile:File;
        private var _processingQueue:Vector.<File> = new Vector.<File>();
        private var _output:ArrayCollection;
        private var _filter:Function;
        private var _onComplete:Function;

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

            trace("Retrieving files from '" + root.nativePath + "'");
            _processingQueue = new Vector.<File>();

            this._filter = filter;
            this._output = new ArrayCollection();
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

            trace("Stopped retrieving files from '" + _currentFile.nativePath + "'");
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
            if(_processingQueue.length == 0)
            {
                _isProcessing = false;
                updateStatusSignal.dispatch("Processing complete");
                _onComplete(_output);
            }
            else
            {
                _isProcessing = true;
                _currentFile = _processingQueue.pop();
                updateStatusSignal.dispatch("Processing directory '" + _currentFile.nativePath + "'");
                _currentFile.addEventListener(FileListEvent.DIRECTORY_LISTING, onDirectoriesRetrieved);
                _currentFile.getDirectoryListingAsync();
            }
        }

        /**
         * Handles processing completed for a file
         */
        private function onDirectoriesRetrieved(event:FileListEvent):void
        {
            _currentFile.removeEventListener(FileListEvent.DIRECTORY_LISTING, onDirectoriesRetrieved);
            _currentFile = null;
            for each(var f:File in event.files)
            {
                processFile(f, _output, _filter);
            }
            // now process the next
            retrieveNextDirectoryListing();
        }

        /*
         * Processes a file to add to either the output or the processing queue
         */
        private function processFile(root:File, output:ArrayCollection, filter:Function):void
        {
            if(root.isDirectory)
            {
                _processingQueue.push(root);
            }
            else
            {
                if(filter == null || (filter != null && filter(root) == true))
                {
                    output.addItem(root);
                }
                else if(filter == null)
                {
                    output.addItem(root);
                }
            }
        }
    }
}
