/**
 *
 */
package com.vango.testing.performance.viewer.data.signals
{
    import com.vango.testing.performance.viewer.data.vo.SaveFileHistoryRequest;

    import org.osflash.signals.Signal;

    public class SaveFileHistorySignal extends Signal
    {
        public function SaveFileHistorySignal()
        {
            super(SaveFileHistoryRequest)
        }
    }
}
