/**
 *
 */
package com.playfish.games.marlin.testing.performance.reporting.analysis
{
    import com.playfish.games.marlin.testing.performance.capture.PerformanceDataEntry;

    public class TestFieldSummary
    {
        /**
         * The field name for this summary
         */
        public function get fieldName():String
        {
            return _fieldName;
        }
        private var _fieldName:String;

        public var testCount:int;
        public var meanTime:Number;
        public var timeVariance:Number;
        public var timeStandardDeviation:Number;

        public var meanMemory:Number;
        public var memoryVariance:Number;
        public var memoryStandardDeviation:Number;

        private var _timeRange:Range = new Range();
        private var _memoryRange:Range = new Range();

        /**
         * Constructor
         * @param name The name of the test field
         */
        public function TestFieldSummary(name:String)
        {
            _fieldName = name;
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
            _timeRange.reset();
            _memoryRange.reset();

            for each(var entry:PerformanceDataEntry in testEntries)
            {
                testCount++;

                // update time ranges
                _timeRange.update(entry.time);
                _memoryRange.update(entry.memory);

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
            trace("> " + _fieldName + " Summary");
            trace(PREFIX + "Average running time was " + meanTime + "ms");
            trace(PREFIX + "Running time ranged between " + _timeRange.minimum + "ms and " + _timeRange.maximum + "ms");
            trace(PREFIX + "Running time variance is " + timeVariance + " and sd is " + timeStandardDeviation);
            trace(PREFIX + "Average memory usage was " + meanMemory + "b");
            trace(PREFIX + "Memory usage ranged between " + _memoryRange.minimum + "b and " + _memoryRange.maximum + "b");
            trace(PREFIX + "Memory variance is " + memoryVariance + " and sd is " + memoryStandardDeviation);
        }
    }
}

class Range
{
    public var minimum:Number;
    public var maximum:Number;

    public function reset():void
    {
        minimum = -1;
        maximum = -1;
    }

    public function update(value:Number):void
    {
        if(minimum < 0)
        {
            minimum = value;
        }
        if(maximum < 0)
        {
            maximum = value;
        }
        if(value < minimum)
        {
            minimum = value;
        }
        if(value > maximum)
        {
            maximum = value;
        }
    }
}