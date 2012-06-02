/**
 *
 */
package com.vango.testing.performance.viewer.controls
{
    import com.vango.testing.performance.viewer.controls.commands.ControlCommandId;
    import com.vango.testing.performance.viewer.controls.commands.ControlSelectedCommand;
    import com.vango.testing.performance.viewer.controls.commands.RunTestsCommand;
    import com.vango.testing.performance.viewer.controls.display.FileHistory;
    import com.vango.testing.performance.viewer.controls.display.FileHistoryComponent;
    import com.vango.testing.performance.viewer.controls.mediator.FileHistoryMediator;
    import com.vango.testing.performance.viewer.controls.display.HeadingPanel;
    import com.vango.testing.performance.viewer.controls.display.HeadingPanelComponent;
    import com.vango.testing.performance.viewer.controls.mediator.HeadingPanelMediator;
    import com.vango.testing.performance.viewer.controls.signals.ControlSelectedSignal;

    import org.robotlegs.mvcs.Command;
    import org.robotlegs.mvcs.SignalCommand;

    public class InstallControls extends SignalCommand
    {
        override public function execute():void
        {
            // map services
            injector.mapClass(Command, RunTestsCommand, ControlCommandId.RUN_TESTS);

            // map views
            mediatorMap.mapView(HeadingPanelComponent, HeadingPanelMediator, HeadingPanel);
            mediatorMap.mapView(FileHistoryComponent, FileHistoryMediator, FileHistory);

            // map signals
            signalCommandMap.mapSignalClass(ControlSelectedSignal, ControlSelectedCommand);
        }
    }
}
