/**
 *
 */
package com.vango.testing.performance.viewer.data.commands
{
    import com.vango.testing.performance.viewer.data.services.FileHistoryService;
    import com.vango.testing.performance.viewer.data.vo.ClearFileHistoryRequest;

    import org.robotlegs.mvcs.SignalCommand;

    public class ClearFileHistoryCommand extends SignalCommand
    {
        [Inject]
        public var request:ClearFileHistoryRequest;
        [Inject]
        public var historyService:FileHistoryService;

        override public function execute():void
        {
            historyService.execute(request);
        }
    }
}
