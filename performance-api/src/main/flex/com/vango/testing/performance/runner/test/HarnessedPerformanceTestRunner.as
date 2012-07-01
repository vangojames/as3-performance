package com.vango.testing.performance.runner.test
{
    import com.vango.testing.performance.capture.PerformanceDataEntry;
    import com.vango.testing.performance.capture.PerformanceTestSet;
    import com.vango.testing.performance.reporting.analysis.Range;
    import com.vango.testing.performance.reporting.analysis.TestFieldSummary;
    import com.vango.testing.performance.reporting.analysis.TestSetSummary;

    import flash.events.UncaughtErrorEvents;
    import flash.net.LocalConnection;
    import flash.net.registerClassAlias;
    import flash.utils.ByteArray;
    import flash.utils.getQualifiedClassName;

    public class HarnessedPerformanceTestRunner extends PerformanceTestRunner
    {
        // Register required class aliases
        {
            registerClassAlias(getQualifiedClassName(TestFieldSummary), TestFieldSummary);
            registerClassAlias(getQualifiedClassName(PerformanceDataEntry), PerformanceDataEntry);
            registerClassAlias(getQualifiedClassName(PerformanceTestSet), PerformanceTestSet);
            registerClassAlias(getQualifiedClassName(TestSetSummary), TestSetSummary);
            registerClassAlias(getQualifiedClassName(Range), Range);
        }

        private var _connection:LocalConnection;
        private var _connectionName:String;

        public function HarnessedPerformanceTestRunner(connectionName:String,  uncaughtErrors:UncaughtErrorEvents = null)
        {
            super(uncaughtErrors);

            onComplete.add(testComplete);
            onFail.add(testFailed);

            this._connectionName = connectionName;

            _connection = new LocalConnection();
            _connection.allowDomain("*");
            _connection.allowInsecureDomain("*");

            log("Test harness connected");
        }

        private function log(...args):void
        {
            _connection.send(_connectionName, AbstractTestHarnessClient.LOG_METHOD, args.join(", "));
        }

        private function testComplete(count:int, testSet:PerformanceTestSet, summary:TestSetSummary):void
        {
            // write in to transportation layer
            var testSetBytes:ByteArray = new ByteArray();
            testSetBytes.writeObject(testSet);
            var testSummaryBytes:ByteArray = new ByteArray();
            testSummaryBytes.writeObject(summary);
            // send to the client
            _connection.send(_connectionName, AbstractTestHarnessClient.TEST_COMPLETE_METHOD, count, testSetBytes, testSummaryBytes);
        }

        private function testFailed(msg:String):void
        {
            _connection.send(_connectionName, AbstractTestHarnessClient.FAIL_METHOD, msg);
        }

        public function allComplete():void
        {
            _connection.send(_connectionName, AbstractTestHarnessClient.ALL_COMPLETE_METHOD);
        }
    }
}
