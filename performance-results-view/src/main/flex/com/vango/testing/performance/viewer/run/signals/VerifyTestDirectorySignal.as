/**
 *
 */
package com.vango.testing.performance.viewer.run.signals
{
    import com.vango.testing.performance.viewer.data.vo.FileEntry;

    import org.osflash.signals.Signal;

    public class VerifyTestDirectorySignal extends Signal
    {
        public function VerifyTestDirectorySignal()
        {
            super(FileEntry);
        }
    }
}
