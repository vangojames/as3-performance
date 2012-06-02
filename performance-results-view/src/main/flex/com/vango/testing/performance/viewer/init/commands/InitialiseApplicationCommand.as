/**
 *
 */
package com.vango.testing.performance.viewer.init.commands
{
    import com.vango.testing.performance.viewer.data.services.FileHistoryService;
    import com.vango.testing.performance.viewer.init.signals.InitialiseCompleteSignal;
    import com.vango.testing.performance.viewer.init.signals.InitialiseFailedSignal;

    import org.robotlegs.mvcs.SignalCommand;

    public class InitialiseApplicationCommand extends SignalCommand
    {
        [Inject]
        public var fileHistoryService:FileHistoryService;
        [Inject]
        public var initialiseCompleteSignal:InitialiseCompleteSignal;
        [Inject]
        public var initialiseFailedSignal:InitialiseFailedSignal;

        override public function execute():void
        {
            fileHistoryService.initialisationFailed.addOnce(initialiseFailedSignal.dispatch);
            fileHistoryService.initialisationComplete.addOnce(initialiseCompleteSignal.dispatch);
            fileHistoryService.initialise();
        }
    }
}
