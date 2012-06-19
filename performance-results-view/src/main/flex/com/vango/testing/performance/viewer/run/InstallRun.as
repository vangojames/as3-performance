/**
 *
 */
package com.vango.testing.performance.viewer.run
{
    import com.vango.testing.performance.viewer.run.commands.VerifyTestDirectoryCommand;
    import com.vango.testing.performance.viewer.run.display.RunView;
    import com.vango.testing.performance.viewer.run.display.RunViewComponent;
    import com.vango.testing.performance.viewer.run.mediator.RunViewMediator;
    import com.vango.testing.performance.viewer.run.services.FileRetrievalService;
    import com.vango.testing.performance.viewer.run.services.TestVerificationService;
    import com.vango.testing.performance.viewer.run.signals.VerifyTestDirectorySignal;

    import org.robotlegs.mvcs.SignalCommand;

    public class InstallRun extends SignalCommand
    {
        override public function execute():void
        {
            injector.mapSingleton(TestVerificationService);
            injector.mapSingleton(FileRetrievalService);

            signalCommandMap.mapSignalClass(VerifyTestDirectorySignal, VerifyTestDirectoryCommand);

            mediatorMap.mapView(RunViewComponent, RunViewMediator, RunView);
        }
    }
}
