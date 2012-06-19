/**
 *
 */
package com.vango.testing.performance.viewer.controls.signals
{
    import org.osflash.signals.Signal;

    public class UpdateStatusSignal extends Signal
    {
        public function UpdateStatusSignal()
        {
            super(String);
        }
    }
}
