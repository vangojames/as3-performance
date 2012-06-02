/**
 *
 */
package com.vango.testing.performance.viewer.controls.display
{
    import com.vango.testing.performance.viewer.data.vo.FileEntry;

    import flash.events.MouseEvent;

    import mx.collections.ArrayCollection;

    import org.osflash.signals.Signal;

    import spark.components.Group;

    public class FileHistory extends Group
    {
        [Bindable]
        public var history:ArrayCollection = new ArrayCollection();
        [Bindable]
        public var selectedEntry:FileEntry = null

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
