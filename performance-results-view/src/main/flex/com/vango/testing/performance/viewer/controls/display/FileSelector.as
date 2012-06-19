/**
 *
 */
package com.vango.testing.performance.viewer.controls.display
{
    import com.vango.testing.performance.viewer.controls.events.FileSelectedEvent;
    import com.vango.testing.performance.viewer.data.vo.FileEntry;

    import flash.events.MouseEvent;

    import mx.collections.ArrayCollection;

    import org.osflash.signals.Signal;

    import spark.components.Group;

    [Event(name="select", type="com.vango.testing.performance.viewer.controls.events.FileSelectedEvent")]
    public class FileSelector extends Group
    {
        [Bindable]
        public var history:ArrayCollection = new ArrayCollection();
        [Bindable]
        public function set selectedEntry(value:FileEntry):void
        {
            _selectedEntry = value;
            if(_selectedEntry != null)
            {
                dispatchEvent(new FileSelectedEvent(FileSelectedEvent.SELECT, selectedEntry));
            }
        }
        public function get selectedEntry():FileEntry
        {
            return _selectedEntry;
        }
        private var _selectedEntry:FileEntry = null

        public const onBrowseSignal:Signal = new Signal();
        public const onClearSignal:Signal = new Signal();

        public var browseWindowTitle:String;
        public var ref:String = null;

        protected function onBrowseClick(event:MouseEvent):void
        {
            onBrowseSignal.dispatch(browseWindowTitle);
        }

        protected function onClearClick(event:MouseEvent):void
        {
            onClearSignal.dispatch();
        }
    }
}
