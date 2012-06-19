/**
 *
 */
package com.vango.testing.performance.viewer.controls.display
{
    import com.vango.testing.performance.viewer.data.vo.FileEntry;

    import flash.events.MouseEvent;

    import org.osflash.signals.Signal;

    import spark.components.HGroup;

    public class TestRunner extends HGroup
    {
        public const runTestsSignal:Signal = new Signal(String);

        public function get testPath():FileEntry
        {
            return _testPath;
        }
        public function set testPath(value:FileEntry):void
        {
            _testPath = value;
            enabled = _testPath != null;
        }
        private var _testPath:FileEntry;

        protected function onRunClick(event:MouseEvent):void
        {
            runTestsSignal.dispatch(testPath.path);
        }
    }
}
