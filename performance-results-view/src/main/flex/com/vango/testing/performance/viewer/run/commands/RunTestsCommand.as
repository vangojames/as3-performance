/**
 *
 */
package com.vango.testing.performance.viewer.run.commands
{
    import com.vango.testing.performance.viewer.run.proxies.TestRunProxy;
    import com.vango.testing.performance.viewer.run.services.compilation.AS3CompilerService;

    import org.robotlegs.mvcs.SignalCommand;

    public class RunTestsCommand extends SignalCommand
    {
        [Inject]
        public var runProxy:TestRunProxy;
        [Inject]
        public var compiler:AS3CompilerService;

        override public function execute():void
        {
            compiler.compileTestSWF("C:\\SDK\\Flex\\flex_sdk_4.6", "C:\\SDK\\Flex\\flex_sdk_4.6\\runtimes\\player\\11.1\\win\\FlashPlayer.exe", runProxy.runData);
        }
    }
}
