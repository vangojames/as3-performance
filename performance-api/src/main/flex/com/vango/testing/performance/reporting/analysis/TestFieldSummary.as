/**
 *
 */
package com.vango.testing.performance.reporting.analysis
{
    import com.vango.testing.performance.capture.PerformanceDataEntry;

    public class TestFieldSummary
    {
        /**
         * The field name for this summary
         */
        public var fieldName:String;

        public var testCount:int;
        public var meanTime:Number;
        public var timeVariance:Number;
        public var timeStandardDeviation:Number;

        public var meanMemory:Number;
        public var memoryVariance:Number;
        public var memoryStandardDeviation:Number;

        public var timeRange:Range = new Range();
        public var memoryRange:Range = new Range();

        /**
         * Constructor
         * @param name The name of the test field
         */
        public function TestFieldSummary(name:String = "")
        {
            fieldName = name;
        }

        /**
         * Summaries the test entries for a test field
         * @param testEntries The entries for the field
         */
        public function summarise(testEntries:Array):void
        {
            meanTime = 0;
            meanMemory = 0;
            testCount = 0;
            timeRange.reset();
            memoryRange.reset();

            for each(var entry:PerformanceDataEntry in testEntries)
            {
                testCount++;

                // update time ranges
                timeRange.update(entry.time);
                memoryRange.update(entry.memory);

                // update mean
                meanTime += entry.time;
                meanMemory += entry.memory;
            }

            meanTime /= testCount;
            meanMemory /= testCount;

            // calculate variance
            timeVariance = 0;
            memoryVariance = 0;
            for each(var entry:PerformanceDataEntry in testEntries)
            {
                // update mean and variance
                timeVariance += ((entry.time - meanTime) * (entry.time - meanTime));
                memoryVariance += ((entry.memory - meanMemory) * (entry.memory - meanMemory));
            }
            timeVariance /= (testCount - 1);
            timeStandardDeviation = Math.sqrt(timeVariance);
            memoryVariance /= (testCount - 1);
            memoryStandardDeviation = Math.sqrt(memoryVariance);

            var PREFIX:String = ">\t- ";
            trace("> " + fieldName + " Summary");
            trace(PREFIX + "Average running time was " + meanTime + "ms");
            trace(PREFIX + "Running time ranged between " + timeRange.minimum + "ms and " + timeRange.maximum + "ms");
            trace(PREFIX + "Running time variance is " + timeVariance + " and sd is " + timeStandardDeviation);
            trace(PREFIX + "Average memory usage was " + meanMemory + "b");
            trace(PREFIX + "Memory usage ranged between " + memoryRange.minimum + "b and " + memoryRange.maximum + "b");
            trace(PREFIX + "Memory variance is " + memoryVariance + " and sd is " + memoryStandardDeviation);
        }
    }
}