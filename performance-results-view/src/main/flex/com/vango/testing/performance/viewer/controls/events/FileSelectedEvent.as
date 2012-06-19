/**
 *
 */
package com.vango.testing.performance.viewer.controls.events
{
    import com.vango.testing.performance.viewer.data.vo.FileEntry;

    import flash.events.Event;

    public class FileSelectedEvent extends Event
    {
        public var file:FileEntry;
        public static const SELECT:String = "select";

        public function FileSelectedEvent(type:String, file:FileEntry)
        {
            super(type, false, false);
            this.file = file;
        }
    }
}
