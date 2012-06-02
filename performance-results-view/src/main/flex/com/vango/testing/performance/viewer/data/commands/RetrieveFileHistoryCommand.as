/**
 *
 */
package com.vango.testing.performance.viewer.data.commands
{
    import com.vango.testing.performance.viewer.data.services.FileHistoryService;
    import com.vango.testing.performance.viewer.data.vo.RetrieveFileHistoryRequest;

    import org.robotlegs.mvcs.SignalCommand;

    public class RetrieveFileHistoryCommand extends SignalCommand
    {
        [Inject]
        public var request:RetrieveFileHistoryRequest;
        [Inject]
        public var service:FileHistoryService;

        override public function execute():void
        {
            service.execute(request);
        }
    }
}
