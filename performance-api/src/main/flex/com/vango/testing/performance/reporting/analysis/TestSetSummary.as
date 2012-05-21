/**
 *
 */
package com.vango.testing.performance.reporting.analysis
{
    import com.vango.testing.performance.capture.PerformanceTestSet;

    import flash.utils.Dictionary;

    public class TestSetSummary
    {
        private var _summaryData:Dictionary = new Dictionary();

        /**
         * Summarises test daya for the specified test set
         * @param testSet The testing test set to summarise
         */
        public function summarise(testSet:PerformanceTestSet):void
        {
            // run through each heading and summarise it
            for each(var testName:String in testSet.headings)
            {
                var fieldSummary:TestFieldSummary = new TestFieldSummary(testName);
                var testEntries:Array = (testSet.entries[testName] as Array);
                fieldSummary.summarise(testEntries);
                _summaryData[testName] = fieldSummary;
            }
        }
    }
}
