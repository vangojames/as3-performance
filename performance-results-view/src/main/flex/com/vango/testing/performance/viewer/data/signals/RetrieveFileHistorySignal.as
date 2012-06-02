/**
 *
 */
package com.vango.testing.performance.viewer.data.signals
{
    import com.vango.testing.performance.viewer.data.vo.RetrieveFileHistoryRequest;

    import org.osflash.signals.Signal;

    public class RetrieveFileHistorySignal extends Signal
    {
        public function RetrieveFileHistorySignal()
        {
            super(RetrieveFileHistoryRequest);
        }
    }
}
