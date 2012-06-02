/**
 *
 */
package com.vango.testing.performance.viewer.io.commands
{
    import com.vango.testing.performance.viewer.io.vo.MultipleFilesBrowsingConfig;

    import flash.events.Event;
    import flash.events.FileListEvent;
    import flash.events.IOErrorEvent;
    import flash.filesystem.File;

    import org.robotlegs.mvcs.SignalCommand;

    public class BrowseForMultipleFilesCommand extends SignalCommand
    {
        [Inject]
        public var config:MultipleFilesBrowsingConfig;

        private var f:File;

        override public function execute():void
        {
            commandMap.detain(this);

            f = config.initialFile;
            addFileListeners();
            f.browseForOpenMultiple(config.windowTitle, config.typeFilter);
        }

        private function addFileListeners():void
        {
            f.addEventListener(FileListEvent.SELECT_MULTIPLE, onFilesSelected);
            f.addEventListener(IOErrorEvent.IO_ERROR, onError);
            f.addEventListener(Event.CANCEL, onFileCancelled);
            f.addEventListener(Event.CLOSE, onFileCancelled);
        }

        private function removeFileListeners():void
        {
            f.removeEventListener(FileListEvent.SELECT_MULTIPLE, onFilesSelected);
            f.removeEventListener(IOErrorEvent.IO_ERROR, onError);
            f.removeEventListener(Event.CANCEL, onFileCancelled);
            f.removeEventListener(Event.CLOSE, onFileCancelled);
        }

        private function onFilesSelected(event:FileListEvent):void
        {
            removeFileListeners();
            config.callback(event.files);
            commandMap.release(this);
        }

        private function onFileCancelled(event:Event):void
        {
            removeFileListeners();
            config.callback(null);
            commandMap.release(this);
        }

        private function onError(event:IOErrorEvent):void
        {
            trace("WARNING FILE BROWSING NOT SUPPORTED");
            removeFileListeners();
            config.callback(null);
            commandMap.release(this);
        }
    }
}
