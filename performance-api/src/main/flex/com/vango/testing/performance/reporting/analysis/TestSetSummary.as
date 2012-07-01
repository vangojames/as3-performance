/**
 *
 */
package com.vango.testing.performance.reporting.analysis
{
    import com.vango.testing.performance.capture.PerformanceTestSet;

    import flash.utils.Dictionary;

    public class TestSetSummary
    {
        public var fieldCount:int;
        public var meanTotalTime:Number;
        public var meanTotalMemory:Number;

        public var summaryData:Dictionary = new Dictionary();

        /**
         * Summarises test daya for the specified test set
         * @param testSet The testing test set to summarise
         */
        public function summarise(testSet:PerformanceTestSet):void
        {
            fieldCount = 0;
            meanTotalTime = 0;
            meanTotalMemory = 0;

            // run through each heading and summarise it
            for each(var testName:String in testSet.headings)
            {
                var fieldSummary:TestFieldSummary = new TestFieldSummary(testName);
                var testEntries:Array = (testSet.entries[testName] as Array);
                fieldSummary.summarise(testEntries);
                summaryData[testName] = fieldSummary;

                meanTotalTime += fieldSummary.meanTime;
                meanTotalMemory += fieldSummary.meanMemory;
                fieldCount++;
            }
        }
    }
}
