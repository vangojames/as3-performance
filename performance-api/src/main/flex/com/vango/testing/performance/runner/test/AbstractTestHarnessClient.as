package com.vango.testing.performance.runner.test
{
    import com.vango.testing.performance.capture.PerformanceDataEntry;
    import com.vango.testing.performance.capture.PerformanceTestSet;
    import com.vango.testing.performance.reporting.analysis.Range;
    import com.vango.testing.performance.reporting.analysis.TestFieldSummary;
    import com.vango.testing.performance.reporting.analysis.TestSetSummary;

    import flash.net.registerClassAlias;
    import flash.utils.ByteArray;
    import flash.utils.getQualifiedClassName;

    public class AbstractTestHarnessClient
    {
        // register required class aliases
        {
            registerClassAlias(getQualifiedClassName(TestFieldSummary), TestFieldSummary);
            registerClassAlias(getQualifiedClassName(PerformanceDataEntry), PerformanceDataEntry);
            registerClassAlias(getQualifiedClassName(PerformanceTestSet), PerformanceTestSet);
            registerClassAlias(getQualifiedClassName(TestSetSummary), TestSetSummary);
            registerClassAlias(getQualifiedClassName(Range), Range);
        }

        public static const LOG_METHOD:String = "log";
        public static const FAIL_METHOD:String = "fail";
        public static const TEST_COMPLETE_METHOD:String = "testComplete";
        public static const ALL_COMPLETE_METHOD:String = "allComplete";

        public final function log(logMsg:String):void
        {
            handleLog(logMsg);
        }

        protected function handleLog(logMsg:String):void
        {
            throw new Error("Method not implemented");
        }

        public final function fail(msg:String):void
        {
            handleFail(msg);
        }

        protected function handleFail(msg:String):void
        {
            throw new Error("Method not implemented");
        }

        public final function testComplete(count:int, testSetBytes:ByteArray, summaryBytes:ByteArray):void
        {
            var testSet:PerformanceTestSet = testSetBytes.readObject() as PerformanceTestSet;
            var summary:TestSetSummary = summaryBytes.readObject() as TestSetSummary;
            handleTestComplete(count, testSet, summary);
        }

        protected function handleTestComplete(count:int, testSet:PerformanceTestSet, summaryBytes:TestSetSummary):void
        {
            throw new Error("Method not implemented");
        }

        public final function allComplete():void
        {
            handleAllComplete();
        }

        protected function handleAllComplete():void
        {
            throw new Error("Method not implemented");
        }
    }
}
