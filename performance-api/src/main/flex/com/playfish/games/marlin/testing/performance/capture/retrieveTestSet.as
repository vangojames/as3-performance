/**
 * Created with IntelliJ IDEA.
 * User: jvango
 * Date: 29/04/12
 * Time: 12:42
 * To change this template use File | Settings | File Templates.
 */
package com.playfish.games.marlin.testing.performance.capture
{
    /**
     * Retrieves performance data based on the target and test set name
     * @param target The target to retrieve for
     * @param testSet The name of the test set to retrieve
     * @return The performance data for this test set and target
     */
    public function retrieveTestSet(target:Object, testSet:String):PerformanceTestSet
    {
        return PerformanceRegistry.instance.retrieve(target).retrieveTestSet(testSet);
    }
}
