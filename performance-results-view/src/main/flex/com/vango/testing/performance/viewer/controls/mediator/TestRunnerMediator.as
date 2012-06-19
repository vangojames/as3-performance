/**
 *
 */
package com.vango.testing.performance.viewer.controls.mediator
{
    import com.vango.testing.performance.viewer.controls.display.TestRunner;

    import org.robotlegs.mvcs.Mediator;

    public class TestRunnerMediator extends Mediator
    {
        [Inject]
        public var testView:TestRunner;

        override public function onRegister():void
        {
            testView.runTestsSignal.add(onRunTests);
            super.onRegister();
        }

        override public function onRemove():void
        {
            testView.runTestsSignal.remove(onRunTests);
            super.onRemove();
        }

        /**
         * Handles running the tests
         */
        private function onRunTests(testSource:String):void
        {
            trace("Running tests from " + testSource);
        }
    }
}
