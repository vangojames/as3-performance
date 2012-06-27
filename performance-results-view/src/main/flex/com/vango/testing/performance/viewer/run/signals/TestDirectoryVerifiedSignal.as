/**
 *
 */
package com.vango.testing.performance.viewer.run.signals
{
    import com.vango.testing.performance.viewer.run.vo.VerificationResult;

    import org.osflash.signals.Signal;

    public class TestDirectoryVerifiedSignal extends Signal
    {
        public function TestDirectoryVerifiedSignal()
        {
            super(VerificationResult);
        }
    }
}
