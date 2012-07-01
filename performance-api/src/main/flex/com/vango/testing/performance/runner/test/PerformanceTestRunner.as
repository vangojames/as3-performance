/**
 *
 */
package com.vango.testing.performance.runner.test
{
    import com.vango.testing.performance.capture.PerformanceTestSet;
    import com.vango.testing.performance.meta.configurations.MethodConfiguration;
    import com.vango.testing.performance.meta.configurations.SnapshotMethodConfiguration;
    import com.vango.testing.performance.meta.parse.PerformanceTestParser;
    import com.vango.testing.performance.reporting.analysis.TestSetSummary;
    import com.vango.testing.performance.runner.RunConfiguration;
    import com.vango.testing.performance.runner.method.MethodRunner;
    import com.vango.testing.performance.runner.method.MethodRunnerMap;
    import com.vango.testing.performance.runner.method.SnapshotMethodRunner;

    import flash.events.UncaughtErrorEvents;
    import flash.system.ApplicationDomain;
    import flash.utils.getQualifiedClassName;

    import org.osflash.signals.Signal;

    public class PerformanceTestRunner
    {
        /**
         * Dispatched on test completion (also dispatches the number of test methods that were tested);
         */
        public function get onComplete():Signal
        {
            return _onComplete;
        }
        private var _onComplete:Signal = new Signal(int, PerformanceTestSet, TestSetSummary);

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
        private var _uncaughtErrors:UncaughtErrorEvents;

        public function PerformanceTestRunner(uncaughtErrors:UncaughtErrorEvents = null)
        {
            _uncaughtErrors = uncaughtErrors;
        }

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
            if(_currentConfiguration.testMethods.length == 0)
            {
                trace("WARNING : no tests were found");
                _onComplete.dispatch(0);
            }
            else
            {
                // execute the test
                execute(name, _currentConfiguration, count);
            }
        }

        /**
         * Executes the run configuration passed in
         * @param name The name of the test
         * @param runConfig The configuration to run
         */
        private function execute(name:String, runConfig:RunConfiguration, count:int):void
        {
            var runnerMap:MethodRunnerMap = new MethodRunnerMap(_uncaughtErrors);
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
            _onComplete.dispatch(_currentConfiguration.testMethods.length, testSet, summary);
        }
    }
}
