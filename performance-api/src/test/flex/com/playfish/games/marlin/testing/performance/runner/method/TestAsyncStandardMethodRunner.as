/**
 *
 */
package com.playfish.games.marlin.testing.performance.runner.method
{
    import com.playfish.games.marlin.testing.performance.meta.configurations.IMethodConfiguration;
    import com.playfish.games.marlin.testing.performance.meta.configurations.MethodConfiguration;
    import com.playfish.games.marlin.testing.performance.meta.tags.PerformanceTestMetaTag;
    import com.playfish.games.marlin.testing.performance.runner.async.AsyncToken;
    import com.playfish.games.marlin.testing.performance.runner.helpers.FakeAsyncTestClass;

    import org.as3commons.reflect.Method;
    import org.as3commons.reflect.Type;
    import org.osflash.signals.Signal;
    import org.osflash.signals.utils.proceedOnSignal;
    import org.osflash.signals.utils.registerFailureSignal;

    public class TestAsyncStandardMethodRunner
    {
        private var _runner:AsyncMethodRunner;
        private var _config:IMethodConfiguration;
        private var _testClass:Class = FakeAsyncTestClass;
        private var _testInstance:FakeAsyncTestClass = new FakeAsyncTestClass();
        private var _testName:String = "myTest";

        [Before]
        public function setup():void
        {
            _config = new MethodConfiguration(PerformanceTestMetaTag.BEFORE);
            var testType:Type = Type.forClass(FakeAsyncTestClass);
            for each(var method:Method in testType.methods)
            {
                if(method.name == "beforeAsyncOne")
                {
                    _config.parse(method);
                }
            }
            _runner = new AsyncMethodRunner();
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
