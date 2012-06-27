/**
 *
 */
package com.vango.testing.performance.viewer.run.signals
{
    import flash.filesystem.File;

    import org.osflash.signals.Signal;

    public class IncludeSwcSignal extends Signal
    {
        public function IncludeSwcSignal()
        {
            super(File);
        }
    }
}
