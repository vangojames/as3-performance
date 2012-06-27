/**
 *
 */
package com.vango.testing.performance.viewer.run
{
    import com.vango.testing.performance.viewer.run.commands.TestDirectoryVerifiedCommand;
    import com.vango.testing.performance.viewer.run.commands.VerifyTestDirectoryCommand;
    import com.vango.testing.performance.viewer.run.display.run.RunView;
    import com.vango.testing.performance.viewer.run.display.run.RunViewComponent;
    import com.vango.testing.performance.viewer.run.mediator.RunViewMediator;
    import com.vango.testing.performance.viewer.run.proxies.TestRunProxy;
    import com.vango.testing.performance.viewer.run.services.AS3ParsingService;
    import com.vango.testing.performance.viewer.run.services.FileRetrievalService;
    import com.vango.testing.performance.viewer.run.services.TestVerificationService;
    import com.vango.testing.performance.viewer.run.signals.TestDirectoryVerifiedSignal;
    import com.vango.testing.performance.viewer.run.signals.VerifyTestDirectorySignal;

    import org.robotlegs.mvcs.SignalCommand;

    public class InstallRun extends SignalCommand
    {
        override public function execute():void
        {
            injector.mapSingleton(TestVerificationService);
            injector.mapSingleton(FileRetrievalService);
            injector.mapSingleton(AS3ParsingService);

            injector.mapSingleton(TestRunProxy);

            signalCommandMap.mapSignalClass(VerifyTestDirectorySignal, VerifyTestDirectoryCommand);
            signalCommandMap.mapSignalClass(TestDirectoryVerifiedSignal, TestDirectoryVerifiedCommand);

            mediatorMap.mapView(RunViewComponent, RunViewMediator, RunView);
        }
    }
}
