/**
 *
 */
package com.vango.testing.performance.viewer.io.commands
{
    import com.vango.testing.performance.viewer.io.vo.DirectoryBrowsingConfig;

    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.filesystem.File;

    import org.robotlegs.mvcs.SignalCommand;

    public class BrowseForDirectoryCommand extends SignalCommand
    {
        [Inject]
        public var config:DirectoryBrowsingConfig;

        private var f:File;

        override public function execute():void
        {
            commandMap.detain(this);

            f = config.initialFile;
            addFileListeners();
            f.browseForDirectory(config.windowTitle);
        }

        private function addFileListeners():void
        {
            f.addEventListener(Event.SELECT, onFileSelected);
            f.addEventListener(IOErrorEvent.IO_ERROR, onError);
            f.addEventListener(Event.CANCEL, onFileCancelled);
            f.addEventListener(Event.CLOSE, onFileCancelled);
        }

        private function removeFileListeners():void
        {
            f.removeEventListener(Event.SELECT, onFileSelected);
            f.removeEventListener(IOErrorEvent.IO_ERROR, onError);
            f.removeEventListener(Event.CANCEL, onFileCancelled);
            f.removeEventListener(Event.CLOSE, onFileCancelled);
        }

        private function onFileSelected(event:Event):void
        {
            removeFileListeners();
            config.callback(f);
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
