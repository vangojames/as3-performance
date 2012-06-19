/**
 *
 */
package com.vango.testing.performance.viewer.run.mediator
{
    import com.vango.testing.performance.viewer.run.display.RunView;
    import com.vango.testing.performance.viewer.run.signals.VerifyTestDirectorySignal;

    import org.robotlegs.mvcs.Mediator;

    public class RunViewMediator extends Mediator
    {
        [Inject]
        public var runView:RunView;
        [Inject]
        public var verifyTestSignal:VerifyTestDirectorySignal;

        override public function onRegister():void
        {
            runView.verifyTestSignal.add(verifyTestSignal.dispatch);
            super.onRegister();
        }

        override public function onRemove():void
        {
            runView.verifyTestSignal.remove(verifyTestSignal.dispatch);
            super.onRemove();
        }
    }
}
