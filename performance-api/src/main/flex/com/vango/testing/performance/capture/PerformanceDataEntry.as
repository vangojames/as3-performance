/**
 * Created with IntelliJ IDEA.
 * User: jvango
 * Date: 27/04/12
 * Time: 19:12
 * To change this template use File | Settings | File Templates.
 */
package com.vango.testing.performance.capture
{
    public class PerformanceDataEntry
    {
        public var time:int;
        public var memory:int;

        public function PerformanceDataEntry(time:int = 0, memory:int = 0)
        {
            this.time = time;
            this.memory = memory;
        }
    }
}
