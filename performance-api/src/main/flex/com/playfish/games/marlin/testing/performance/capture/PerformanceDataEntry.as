/**
 * Created with IntelliJ IDEA.
 * User: jvango
 * Date: 27/04/12
 * Time: 19:12
 * To change this template use File | Settings | File Templates.
 */
package com.playfish.games.marlin.testing.performance.capture
{
    public class PerformanceDataEntry
    {
        public var time:int;
        public var memory:int;

        public function PerformanceDataEntry(time:int, memory:int)
        {
            this.time = time;
            this.memory = memory;
        }
    }
}
