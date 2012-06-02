/**
 *
 */
package com.vango.testing.performance.viewer.io.signals
{
    import com.vango.testing.performance.viewer.io.vo.FileBrowsingConfig;

    import org.osflash.signals.Signal;

    public class BrowseForFileSignal extends Signal
    {
        public function BrowseForFileSignal()
        {
            super(FileBrowsingConfig);
        }
    }
}
