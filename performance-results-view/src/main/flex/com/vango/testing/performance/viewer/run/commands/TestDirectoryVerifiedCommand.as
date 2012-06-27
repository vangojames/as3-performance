/**
 *
 */
package com.vango.testing.performance.viewer.run.commands
{
    import com.vango.testing.performance.viewer.run.proxies.TestRunProxy;
    import com.vango.testing.performance.viewer.run.vo.VerificationResult;

    import org.robotlegs.mvcs.SignalCommand;

    public class TestDirectoryVerifiedCommand extends SignalCommand
    {
        [Inject]
        public var result:VerificationResult;
        [Inject]
        public var testProxy:TestRunProxy;

        override public function execute():void
        {
            trace("VERIFIED");
            testProxy.setTests(result.testList);
        }
    }
}
