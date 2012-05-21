/**
 * Created with IntelliJ IDEA.
 * User: jvango
 * Date: 29/04/12
 * Time: 12:43
 * To change this template use File | Settings | File Templates.
 */
package com.playfish.games.marlin.testing.performance.capture
{
    /**
     * Clears the test set associated with the specific target and testSet
     * @param target The target object to identify the test set
     * @param testSet The test set to clear
     * @return True if the set was cleared succesfully
     */
    public function clearTestSet(target:Object, testSet:String):Boolean
    {
        return PerformanceRegistry.instance.retrieve(target).removeTestSet(testSet);
    }
}
