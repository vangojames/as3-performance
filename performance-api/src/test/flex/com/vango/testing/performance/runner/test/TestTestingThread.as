/**
 *
 */
package com.vango.testing.performance.runner.test
{
    import com.vango.testing.performance.capture.clearTestSet;
    import com.vango.testing.performance.meta.configurations.MethodConfiguration;
    import com.vango.testing.performance.meta.configurations.SnapshotMethodConfiguration;
    import com.vango.testing.performance.meta.parse.PerformanceTestParser;
    import com.vango.testing.performance.reporting.csv.reportPerformanceCSV;
    import com.vango.testing.performance.runner.RunConfiguration;
    import com.vango.testing.performance.runner.helpers.FakeTestClass;
    import com.vango.testing.performance.runner.method.MethodRunner;
    import com.vango.testing.performance.runner.method.MethodRunnerMap;
    import com.vango.testing.performance.runner.method.SnapshotMethodRunner;

    import org.hamcrest.assertThat;
    import org.hamcrest.collection.array;
    import org.hamcrest.collection.arrayWithSize;
    import org.hamcrest.collection.everyItem;
    import org.hamcrest.core.allOf;
    import org.hamcrest.object.equalTo;
    import org.hamcrest.object.hasProperty;
    import org.osflash.signals.Signal;
    import org.osflash.signals.utils.SignalAsyncEvent;
    import org.osflash.signals.utils.handleSignal;
    import org.osflash.signals.utils.registerFailureSignal;

    public class TestTestingThread
    {
        private var _runConfiguration:RunConfiguration;
        private var _testingThread:TestingThread;
        private var _onCompleteSignal:Signal;
        private var _onFailSignal:Signal;
        private var _context:ThreadContext;

        [Before]
        public function setup():void
        {
            var parser:PerformanceTestParser = new PerformanceTestParser();
            _runConfiguration = parser.parse(FakeTestClass);
            _testingThread = new TestingThread();
            _testingThread.onTestCreated = new Signal();
            _onCompleteSignal = new Signal();
            _onFailSignal = new Signal();
            var map:MethodRunnerMap = new MethodRunnerMap();
            map.map(MethodConfiguration, MethodRunner);
            map.map(SnapshotMethodConfiguration, SnapshotMethodRunner);
            _context = new ThreadContext(0, 30, _onCompleteSignal.dispatch, _onFailSignal.dispatch, map);
        }

        [After]
        public function tearDown():void
        {
            _runConfiguration = null;
            _testingThread.onTestCreated.removeAll();
            _testingThread.destroy();
            _testingThread = null;
            clearTestSet(FakeTestClass, "myTest");
        }

        [Test(async)]
        public function whenThreadRun_threadExecutesCorrectCallCountInCorrectOrder():void
        {
            var generatedTests:Vector.<FakeTestClass> = new Vector.<FakeTestClass>();
            function onTestCreated(test:FakeTestClass):void
            {
                generatedTests.push(test);
            }
            _testingThread.onTestCreated.add(onTestCreated);
            _context.callCount = 100;
            handleSignal(this, _onCompleteSignal, checkTestCalls, 1000, generatedTests);
            registerFailureSignal(this, _onFailSignal);
            _testingThread.start("myTest", _context, _runConfiguration);

            function checkTestCalls(event:SignalAsyncEvent, tests:Vector.<FakeTestClass>):void
            {
                assertThat(tests, allOf(
                        arrayWithSize(100),
                        everyItem(
                                allOf(
                                        hasProperty("beforeCount", equalTo(1)),
                                        hasProperty("testCount", equalTo(10001)),
                                        hasProperty("afterCount", equalTo(1)),
                                        hasProperty("runOrder", allOf(
                                                arrayWithSize(4),
                                                array("beforeOne", "testOne", "testTwo", "afterOne")
                                            ))
                                )
                        )
                ));

                var pf:String = reportPerformanceCSV(_runConfiguration.testClass, "myTest", true);
            }
        }
    }
}
