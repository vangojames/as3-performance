/**
 *
 */
package com.vango.testing.performance.viewer.run.signals
{
    import com.vango.testing.performance.viewer.run.vo.RunData;

    import org.osflash.signals.Signal;

    public class RunDataUpdatedSignal extends Signal
    {
        public function RunDataUpdatedSignal()
        {
            super(RunData);
        }
    }
}
