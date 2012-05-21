/**
 * Created with IntelliJ IDEA.
 * User: jvango
 * Date: 27/04/12
 * Time: 19:17
 * To change this template use File | Settings | File Templates.
 */
package com.vango.testing.performance.capture
{
    /**
     * Takes a testing snapshot and stores the data against the target, test set name and data set
     * @param target The target to use for identifying the snapshot in a group
     * @param testSet The actual test set to add the snapshot to
     * @param dataSet The identifier for the snapshot
     * @param time The time to set for the snapshot. If not passed then @see flash.utils.getTimer is used
     * @param memory The memory to set for the snapshot. If not passed then @see flash.system.System#totalMemory is used
     */
    public function takeSnapshot(target:Object, testSet:String, dataSet:String, time:int = -1, memory:int = -1):void
    {
        PerformanceRegistry.instance.retrieve(target).retrieveTestSet(testSet).takeSnapshot(dataSet, time, memory);
    }
}
