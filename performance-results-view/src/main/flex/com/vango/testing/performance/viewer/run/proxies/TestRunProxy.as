/**
 *
 */
package com.vango.testing.performance.viewer.run.proxies
{
    import com.vango.testing.performance.viewer.run.signals.RunDataUpdatedSignal;
    import com.vango.testing.performance.viewer.run.vo.RunData;

    import flash.filesystem.File;

    public class TestRunProxy
    {
        [Inject]
        public var runDataUpdatedSignal:RunDataUpdatedSignal;

        public function set runData(data:RunData):void
        {
            _runData = data;
            runDataUpdatedSignal.dispatch(_runData);
        }
        public function get runData():RunData
        {
            return _runData;
        }
        private var _runData:RunData;

        public function includeSource(source:File):void
        {
            if(!_runData.externalSources.contains(source.nativePath))
            {
                _runData.externalSources.addItem(source.nativePath);
            }
        }

        public function includeSwc(source:File):void
        {
            if(!_runData.externalSwcs.contains(source.nativePath))
            {
                _runData.externalSwcs.addItem(source.nativePath);
            }
        }
    }
}
