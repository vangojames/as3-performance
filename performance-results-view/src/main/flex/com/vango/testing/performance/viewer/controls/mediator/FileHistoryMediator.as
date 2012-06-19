/**
 *
 */
package com.vango.testing.performance.viewer.controls.mediator
{
    import com.vango.testing.performance.viewer.controls.display.*;
    import com.vango.testing.performance.viewer.data.signals.ClearFileHistorySignal;
    import com.vango.testing.performance.viewer.data.signals.RetrieveFileHistorySignal;
    import com.vango.testing.performance.viewer.data.signals.SaveFileHistorySignal;
    import com.vango.testing.performance.viewer.data.vo.ClearFileHistoryRequest;
    import com.vango.testing.performance.viewer.data.vo.FileEntry;
    import com.vango.testing.performance.viewer.data.vo.RetrieveFileHistoryRequest;
    import com.vango.testing.performance.viewer.data.vo.SaveFileHistoryRequest;
    import com.vango.testing.performance.viewer.io.signals.BrowseForDirectorySignal;
    import com.vango.testing.performance.viewer.io.vo.DirectoryBrowsingConfig;

    import flash.filesystem.File;

    import mx.collections.ArrayCollection;

    import org.robotlegs.mvcs.Mediator;

    public class FileHistoryMediator extends Mediator
    {
        [Inject]
        public var historyView:FileSelector;
        [Inject]
        public var retrieveFileHistorySignal:RetrieveFileHistorySignal;
        [Inject]
        public var saveFileHistorySignal:SaveFileHistorySignal;
        [Inject]
        public var clearFileHistorySignal:ClearFileHistorySignal;
        [Inject]
        public var browseForDirectorySignal:BrowseForDirectorySignal;

        override public function onRegister():void
        {
            super.onRegister();
            historyView.onBrowseSignal.add(onBrowse);
            retrieveFileHistorySignal.dispatch(new RetrieveFileHistoryRequest(historyView.ref, onHistoryRetrieved));
            historyView.onClearSignal.add(onClearHistory);
        }

        override public function onRemove():void
        {
            super.onRemove();
            historyView.onBrowseSignal.remove(onBrowse);
        }

        private function onBrowse(title:String):void
        {
            var initialFile:File = historyView.selectedEntry ? new File(historyView.selectedEntry.path) : File.desktopDirectory;
            browseForDirectorySignal.dispatch(new DirectoryBrowsingConfig(initialFile, title, onBrowseResponse));
        }

        private function onBrowseResponse(f:File):void
        {
            if(f == null)
            {
                trace("Cancelled / Closed");
            }
            else
            {
                saveFileHistorySignal.dispatch(new SaveFileHistoryRequest(historyView.ref, onHistorySaved, f));
            }
        }

        /**
         * Handles history updates for a specific reference
         */
        private function onHistoryRetrieved(history:Vector.<FileEntry>):void
        {
            var historyArray:ArrayCollection = historyView.history;
            historyArray.removeAll();
            var l:int = history.length;
            if(l)
            {
                for(var i:int = 0; i < l; i++)
                {
                    historyArray.addItemAt(history[i], i);
                }
                historyView.selectedEntry = historyArray.getItemAt(0) as FileEntry;
            }
        }

        /**
         * Handles history being saved
         */
        private function onHistorySaved(newEntry:FileEntry):void
        {
            historyView.history.addItemAt(newEntry, 0);
            historyView.selectedEntry = newEntry;
        }

        /**
         * Clears the history
         */
        private function onClearHistory():void
        {
            clearFileHistorySignal.dispatch(new ClearFileHistoryRequest(historyView.ref, onHistoryCleared));
        }

        /**
         * Handles history being cleared
         */
        private function onHistoryCleared():void
        {
            historyView.history.removeAll();
            historyView.selectedEntry = null;
        }
    }
}
