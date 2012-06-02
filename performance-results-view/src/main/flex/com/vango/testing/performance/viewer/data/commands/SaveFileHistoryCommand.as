/**
 *
 */
package com.vango.testing.performance.viewer.data.commands
{
    import com.vango.testing.performance.viewer.data.services.FileHistoryService;
    import com.vango.testing.performance.viewer.data.vo.SaveFileHistoryRequest;

    import org.robotlegs.mvcs.SignalCommand;

    public class SaveFileHistoryCommand extends SignalCommand
    {
        [Inject]
        public var request:SaveFileHistoryRequest;
        [Inject]
        public var fileHistoryService:FileHistoryService;

        override public function execute():void
        {
            fileHistoryService.execute(request);
        }
    }
}
