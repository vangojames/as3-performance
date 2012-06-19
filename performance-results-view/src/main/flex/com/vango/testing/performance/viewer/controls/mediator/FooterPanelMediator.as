/**
 *
 */
package com.vango.testing.performance.viewer.controls.mediator
{
    import com.vango.testing.performance.viewer.controls.display.FooterPanel;
    import com.vango.testing.performance.viewer.controls.signals.UpdateStatusSignal;

    import org.robotlegs.mvcs.Mediator;

    public class FooterPanelMediator extends Mediator
    {
        [Inject]
        public var footerPanel:FooterPanel;
        [Inject]
        public var updateStatusSignal:UpdateStatusSignal;

        override public function onRegister():void
        {
            updateStatusSignal.add(onUpdateStatus);
            super.onRegister();
        }

        override public function onRemove():void
        {
            updateStatusSignal.remove(onUpdateStatus);
            super.onRemove();
        }

        private function onUpdateStatus(status:String):void
        {
            footerPanel.status = status;
        }
    }
}
