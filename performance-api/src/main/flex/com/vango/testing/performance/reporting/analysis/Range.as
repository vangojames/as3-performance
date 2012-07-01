package com.vango.testing.performance.reporting.analysis
{
    public class Range
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
}
