/**
 *
 */
package com.vango.testing.performance.viewer.controls
{
    import com.vango.testing.performance.viewer.controls.commands.ControlSelectedCommand;
    import com.vango.testing.performance.viewer.controls.display.FileSelector;
    import com.vango.testing.performance.viewer.controls.display.FileSelectorComponent;
    import com.vango.testing.performance.viewer.controls.display.FooterPanel;
    import com.vango.testing.performance.viewer.controls.display.FooterPanelComponent;
    import com.vango.testing.performance.viewer.controls.display.TestRunner;
    import com.vango.testing.performance.viewer.controls.display.TestRunnerComponent;
    import com.vango.testing.performance.viewer.controls.mediator.FileHistoryMediator;
    import com.vango.testing.performance.viewer.controls.mediator.FooterPanelMediator;
    import com.vango.testing.performance.viewer.controls.mediator.TestRunnerMediator;
    import com.vango.testing.performance.viewer.controls.signals.ControlSelectedSignal;
    import com.vango.testing.performance.viewer.controls.signals.UpdateStatusSignal;

    import org.robotlegs.mvcs.SignalCommand;

    public class InstallControls extends SignalCommand
    {
        override public function execute():void
        {
            // map views
            mediatorMap.mapView(FileSelectorComponent, FileHistoryMediator, FileSelector);
            mediatorMap.mapView(TestRunnerComponent, TestRunnerMediator, TestRunner);
            mediatorMap.mapView(FooterPanelComponent, FooterPanelMediator, FooterPanel);

            // map signals
            injector.mapSingleton(UpdateStatusSignal);
            signalCommandMap.mapSignalClass(ControlSelectedSignal, ControlSelectedCommand);
        }
    }
}
