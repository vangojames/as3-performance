/**
 *
 */
package com.vango.testing.performance.viewer.data.signals
{
    import com.vango.testing.performance.viewer.data.vo.ClearFileHistoryRequest;

    import org.osflash.signals.Signal;

    public class ClearFileHistorySignal extends Signal
    {
        public function ClearFileHistorySignal()
        {
            super(ClearFileHistoryRequest);
        }
    }
}
