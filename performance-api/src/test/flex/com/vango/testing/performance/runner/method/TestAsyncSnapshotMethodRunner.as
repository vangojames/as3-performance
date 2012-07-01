/**
 *
 */
package com.vango.testing.performance.runner.method
{
    import com.vango.testing.performance.capture.PerformanceDataEntry;
    import com.vango.testing.performance.capture.PerformanceTestSet;
    import com.vango.testing.performance.capture.clearTestSet;
    import com.vango.testing.performance.capture.retrieveTestSet;
    import com.vango.testing.performance.meta.configurations.IMethodConfiguration;
    import com.vango.testing.performance.meta.configurations.SnapshotMethodConfiguration;
    import com.vango.testing.performance.meta.tags.PerformanceTestMetaTag;
    import com.vango.testing.performance.runner.async.AsyncToken;
    import com.vango.testing.performance.runner.helpers.FakeAsyncTestClass;

    import org.as3commons.reflect.Method;
    import org.as3commons.reflect.Type;
    import org.hamcrest.assertThat;
    import org.hamcrest.collection.array;
    import org.hamcrest.collection.arrayWithSize;
    import org.hamcrest.core.allOf;
    import org.hamcrest.object.hasProperty;
    import org.hamcrest.object.instanceOf;
    import org.osflash.signals.Signal;
    import org.osflash.signals.utils.SignalAsyncEvent;
    import org.osflash.signals.utils.handleSignal;
    import org.osflash.signals.utils.proceedOnSignal;
    import org.osflash.signals.utils.registerFailureSignal;

    public class TestAsyncSnapshotMethodRunner
    {
        private var _runner:AsyncSnapshotMethodRunner;
        private var _config:IMethodConfiguration;
        private var _testClass:Class = FakeAsyncTestClass;
        private var _testInstance:FakeAsyncTestClass = new FakeAsyncTestClass();
        private var _testName:String = "myTest";

        [Before]
        public function setup():void
        {
            _config = new SnapshotMethodConfiguration(PerformanceTestMetaTag.TEST);
            var testType:Type = Type.forClass(FakeAsyncTestClass);
            for each(var method:Method in testType.methods)
            {
                if(method.name == "testAsyncOne")
                {
                    _config.parse(method);
                }
            }
            _runner = new AsyncSnapshotMethodRunner(null);
        }

        [After]
        public function tearDown():void
        {
            clearTestSet(_testClass, _testName);
        }

        [Test(async)]
        public function whenExecuted_givenAllPropertiesCorrect_completeIsFired():void
        {
            var completeSignal:Signal = new Signal();
            var failSignal:Signal = new Signal();
            proceedOnSignal(this, completeSignal);
            registerFailureSignal(this, failSignal);
            _runner.execute(_testClass, _testName, _testInstance, _config, new AsyncToken(this, completeSignal.dispatch, failSignal.dispatch));
        }

        [Test(async)]
        public function whenExecuted_givenAllPropertiesCorrect_snapshotIsTaken():void
        {
            var completeSignal:Signal = new Signal();
            var failSignal:Signal = new Signal();
            handleSignal(this, completeSignal, onComplete);
            registerFailureSignal(this, failSignal);
            _runner.execute(_testClass, _testName, _testInstance, _config, new AsyncToken(this, completeSignal.dispatch, failSignal.dispatch));

            function onComplete(event:SignalAsyncEvent, data:Object):void
            {
                var testSet:PerformanceTestSet = retrieveTestSet(_testClass, _testName);
                assertThat(testSet.entries, hasProperty("testAsyncOne", allOf(arrayWithSize(1), array(instanceOf(PerformanceDataEntry)))));
            }
        }

        [Test(async)]
        public function whenExecuted_givenPropertiesNotCorrect_failIsFired():void
        {
            var completeSignal:Signal = new Signal();
            var failSignal:Signal = new Signal();
            proceedOnSignal(this, failSignal);
            registerFailureSignal(this, completeSignal);
            _runner.execute(_testClass, _testName, null, _config, new AsyncToken(this, completeSignal.dispatch, failSignal.dispatch));
        }
    }
}
