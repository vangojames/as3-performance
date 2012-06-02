/**
 *
 */
package com.vango.testing.performance.viewer.io.signals
{
    import com.vango.testing.performance.viewer.io.vo.MultipleFilesBrowsingConfig;

    import org.osflash.signals.Signal;

    public class BrowseForMultipleFilesSignal extends Signal
    {
        public function BrowseForMultipleFilesSignal()
        {
            super(MultipleFilesBrowsingConfig)
        }
    }
}
