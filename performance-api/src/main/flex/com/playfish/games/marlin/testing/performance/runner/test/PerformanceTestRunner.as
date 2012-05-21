/**
 *
 */
package com.playfish.games.marlin.testing.performance.runner.test
{
    import com.playfish.games.marlin.testing.performance.capture.PerformanceTestSet;
    import com.playfish.games.marlin.testing.performance.meta.configurations.MethodConfiguration;
    import com.playfish.games.marlin.testing.performance.meta.configurations.SnapshotMethodConfiguration;
    import com.playfish.games.marlin.testing.performance.meta.parse.PerformanceTestParser;
    import com.playfish.games.marlin.testing.performance.reporting.analysis.TestSetSummary;
    import com.playfish.games.marlin.testing.performance.runner.RunConfiguration;
    import com.playfish.games.marlin.testing.performance.runner.method.MethodRunner;
    import com.playfish.games.marlin.testing.performance.runner.method.MethodRunnerMap;
    import com.playfish.games.marlin.testing.performance.runner.method.SnapshotMethodRunner;

    import flash.system.ApplicationDomain;
    import flash.utils.getQualifiedClassName;

    import org.osflash.signals.Signal;

    public class PerformanceTestRunner
    {
        /**
         * Dispatched on test completion
         */
        public function get onComplete():Signal
        {
            return _onComplete;
        }
        private var _onComplete:Signal = new Signal();

        /**
         * Dispatched on test failure
         */
        public function get onFail():Signal
        {
            return _onFail;
        }
        private var _onFail:Signal = new Signal();

        private var _testParser:PerformanceTestParser = new PerformanceTestParser();
        private var _currentConfiguration:RunConfiguration;
        private var _testThread:TestingThread = new TestingThread();

        /**
         * Runs all the test on test object
         */
        public function run(clazz:Class, name:String = "", count:int = 100):void
        {
            // create a test name if there isn't one
            if(name == "")
            {
                name = getQualifiedClassName(clazz);
            }
            // parse the test into a run configuration
            _currentConfiguration = _testParser.parse(clazz, ApplicationDomain.currentDomain);
            // execute the test
            execute(name, _currentConfiguration, count);
        }

        /**
         * Executes the run configuration passed in
         * @param name The name of the test
         * @param runConfig The configuration to run
         */
        private function execute(name:String, runConfig:RunConfiguration, count:int):void
        {
            var runnerMap:MethodRunnerMap = new MethodRunnerMap();
            runnerMap.map(MethodConfiguration, MethodRunner);
            runnerMap.map(SnapshotMethodConfiguration, SnapshotMethodRunner);
            var threadContext:ThreadContext = new ThreadContext(count, 10, onThreadComplete, onThreadFailed, runnerMap);
            _testThread.start(name, threadContext, runConfig);
        }

        /**
         * Handles thread failure
         */
        private function onThreadFailed(msg:Object):void
        {
            trace("Performance testing failed");
            _onFail.dispatch(msg);
        }

        /**
         * Handles the thread completion
         */
        private function onThreadComplete(testSet:PerformanceTestSet):void
        {
            var summary:TestSetSummary = new TestSetSummary();
            summary.summarise(testSet);
            _onComplete.dispatch();
        }
    }
}
