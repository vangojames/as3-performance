/**
 *
 */
package com.vango.testing.performance.viewer.controls.signals
{
    import com.vango.testing.performance.viewer.controls.vo.ControlContext;

    import org.osflash.signals.Signal;

    public class ControlSelectedSignal extends Signal
    {
        public function ControlSelectedSignal()
        {
            super(ControlContext);
        }
    }
}
