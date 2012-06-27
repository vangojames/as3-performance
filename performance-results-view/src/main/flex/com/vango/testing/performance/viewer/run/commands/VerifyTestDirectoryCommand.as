/**
 *
 */
package com.vango.testing.performance.viewer.run.commands
{
    import com.vango.testing.performance.viewer.data.vo.FileEntry;
    import com.vango.testing.performance.viewer.run.services.TestVerificationService;

    import org.robotlegs.mvcs.SignalCommand;

    public class VerifyTestDirectoryCommand extends SignalCommand
    {
        [Inject]
        public var testVerificationService:TestVerificationService;
        [Inject]
        public var fileEntry:FileEntry;

        override public function execute():void
        {
            testVerificationService.verifyTestDirectory(fileEntry);
        }
    }
}
