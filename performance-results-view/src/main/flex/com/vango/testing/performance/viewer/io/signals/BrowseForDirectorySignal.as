/**
 *
 */
package com.vango.testing.performance.viewer.io.signals
{
    import com.vango.testing.performance.viewer.io.vo.DirectoryBrowsingConfig;

    import org.osflash.signals.Signal;

    public class BrowseForDirectorySignal extends Signal
    {
        public function BrowseForDirectorySignal()
        {
            super(DirectoryBrowsingConfig);
        }
    }
}
