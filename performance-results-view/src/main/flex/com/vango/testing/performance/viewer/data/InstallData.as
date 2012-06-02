/**
 *
 */
package com.vango.testing.performance.viewer.data
{
    import com.vango.testing.performance.viewer.data.commands.ClearFileHistoryCommand;
    import com.vango.testing.performance.viewer.data.commands.RetrieveFileHistoryCommand;
    import com.vango.testing.performance.viewer.data.commands.SaveFileHistoryCommand;
    import com.vango.testing.performance.viewer.data.services.FileHistoryService;
    import com.vango.testing.performance.viewer.data.signals.ClearFileHistorySignal;
    import com.vango.testing.performance.viewer.data.signals.RetrieveFileHistorySignal;
    import com.vango.testing.performance.viewer.data.signals.SaveFileHistorySignal;

    import org.robotlegs.mvcs.SignalCommand;

    public class InstallData extends SignalCommand
    {
        override public function execute():void
        {
            injector.mapSingleton(FileHistoryService);

            signalCommandMap.mapSignalClass(RetrieveFileHistorySignal, RetrieveFileHistoryCommand);
            signalCommandMap.mapSignalClass(SaveFileHistorySignal, SaveFileHistoryCommand);
            signalCommandMap.mapSignalClass(ClearFileHistorySignal, ClearFileHistoryCommand);

        }
    }
}
