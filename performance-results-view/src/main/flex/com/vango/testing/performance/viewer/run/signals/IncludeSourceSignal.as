/**
 *
 */
package com.vango.testing.performance.viewer.run.signals
{
    import flash.filesystem.File;

    import org.osflash.signals.Signal;

    public class IncludeSourceSignal extends Signal
    {
        public function IncludeSourceSignal()
        {
            super(File);
        }
    }
}
