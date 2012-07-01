/**
 *
 */
package com.vango.testing.performance.runner.test
{
    import com.vango.testing.performance.capture.clearTestSet;
    import com.vango.testing.performance.runner.helpers.FakeTestClass;
    import com.vango.testing.performance.runner.helpers.FakeTestClassThatFails;

    import flash.display.DisplayObject;

    import org.fluint.uiImpersonation.IVisualTestEnvironment;
    import org.fluint.uiImpersonation.UIImpersonator;
    import org.hamcrest.assertThat;
    import org.hamcrest.core.isA;
    import org.hamcrest.object.equalTo;
    import org.hamcrest.object.instanceOf;
    import org.osflash.signals.utils.SignalAsyncEvent;
    import org.osflash.signals.utils.handleSignal;
    import org.osflash.signals.utils.proceedOnSignal;
    import org.osflash.signals.utils.registerFailureSignal;

    public class TestPerformanceTestRunner
    {
        private var runner:PerformanceTestRunner;

        [Before]
        public function setup():void
        {
            runner = new PerformanceTestRunner();
        }

        [After]
        public function tearDown():void
        {
            runner = null;
            clearTestSet(FakeTestClass, "myTest");
        }

        [Test(async)]
        public function whenTestRun_givenHasTests_correctCountIsDispatched():void
        {
            handleSignal(this, runner.onComplete, onRunComplete, 100000);
            runner.run(FakeTestClass, "myTest", 100);

            function onRunComplete(event:SignalAsyncEvent, data:Object = null):void
            {
                assertThat(event.args[0], isA(instanceOf(int)));
                assertThat(event.args[0], equalTo(2));
            }
        }

        [Ignore]
        [Test(async)]
        public function whenTestRun_givenHasTestsThatFail_failIsDispatched():void
        {
            proceedOnSignal(this, runner.onFail, 100000);
            registerFailureSignal(this, runner.onComplete);
            runner.run(FakeTestClassThatFails, "myTest", 100);
        }
    }
}
