package com.vango.testing.performance.viewer.run.services.running
{
    import com.vango.testing.performance.capture.PerformanceTestSet;
    import com.vango.testing.performance.reporting.analysis.TestSetSummary;
    import com.vango.testing.performance.runner.test.AbstractTestHarnessClient;

    import org.osflash.signals.Signal;

    public class TestHarnessClient extends AbstractTestHarnessClient
    {
        public const onTestComplete:Signal = new Signal();
        public const onTestFailed:Signal = new Signal();
        public const onAllTestsComplete:Signal = new Signal();

        override protected function handleLog(logString:String):void
        {
            trace(logString);
        }

        override protected function handleTestComplete(count:int, testSet:PerformanceTestSet, summaryBytes:TestSetSummary):void
        {
            onTestComplete.dispatch();
        }

        override protected function handleFail(msg:String):void
        {
            trace("FAILED");
            onTestFailed.dispatch();
        }

        override protected function handleAllComplete():void
        {
            trace("Shutdown");
            onAllTestsComplete.dispatch();
        }
    }
}
