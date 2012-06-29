/**
 *
 */
package com.vango.testing.performance.viewer.run
{
    import com.vango.testing.performance.viewer.run.commands.IncludeSourceCommand;
    import com.vango.testing.performance.viewer.run.commands.IncludeSwcCommand;
    import com.vango.testing.performance.viewer.run.commands.RunTestsCommand;
    import com.vango.testing.performance.viewer.run.commands.VerifyTestDirectoryCommand;
    import com.vango.testing.performance.viewer.run.display.run.RunView;
    import com.vango.testing.performance.viewer.run.display.run.RunViewComponent;
    import com.vango.testing.performance.viewer.run.mediator.RunViewMediator;
    import com.vango.testing.performance.viewer.run.proxies.TestRunProxy;
    import com.vango.testing.performance.viewer.run.services.AS3CompilerService;
    import com.vango.testing.performance.viewer.run.services.AS3ParsingService;
    import com.vango.testing.performance.viewer.run.services.FileRetrievalService;
    import com.vango.testing.performance.viewer.run.services.TestVerificationService;
    import com.vango.testing.performance.viewer.run.services.template.TestTemplateService;
    import com.vango.testing.performance.viewer.run.signals.IncludeSourceSignal;
    import com.vango.testing.performance.viewer.run.signals.IncludeSwcSignal;
    import com.vango.testing.performance.viewer.run.signals.RunDataUpdatedSignal;
    import com.vango.testing.performance.viewer.run.signals.RunTestsSignal;
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
            injector.mapSingleton(AS3CompilerService);
            injector.mapSingleton(TestTemplateService);

            injector.mapSingleton(TestRunProxy);

            signalCommandMap.mapSignalClass(VerifyTestDirectorySignal, VerifyTestDirectoryCommand);
            signalCommandMap.mapSignalClass(IncludeSourceSignal, IncludeSourceCommand);
            signalCommandMap.mapSignalClass(IncludeSwcSignal, IncludeSwcCommand);
            signalCommandMap.mapSignalClass(RunTestsSignal, RunTestsCommand);

            injector.mapSingleton(TestDirectoryVerifiedSignal);
            injector.mapSingleton(RunDataUpdatedSignal);

            mediatorMap.mapView(RunViewComponent, RunViewMediator, RunView);
        }
    }
}
