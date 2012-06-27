/**
 *
 */
package com.vango.testing.performance.viewer.run.mediator
{
    import com.vango.testing.performance.viewer.run.display.run.RunView;
    import com.vango.testing.performance.viewer.run.signals.TestDirectoryVerifiedSignal;
    import com.vango.testing.performance.viewer.run.signals.VerifyTestDirectorySignal;

    import org.robotlegs.mvcs.Mediator;

    public class RunViewMediator extends Mediator
    {
        [Inject]
        public var runView:RunView;
        [Inject]
        public var verifyTestSignal:VerifyTestDirectorySignal;
        [Inject]
        public var testDirectoryVerifiedSignal:TestDirectoryVerifiedSignal;

        override public function onRegister():void
        {
            runView.verifyTestSignal.add(verifyTestSignal.dispatch);
            testDirectoryVerifiedSignal.add(runView.onTestVerified);
            super.onRegister();
        }

        override public function onRemove():void
        {
            runView.verifyTestSignal.remove(verifyTestSignal.dispatch);
            testDirectoryVerifiedSignal.remove(runView.onTestVerified);
            super.onRemove();
        }
    }
}
