/**
 * Created with IntelliJ IDEA.
 * User: jvango
 * Date: 29/04/12
 * Time: 21:48
 * To change this template use File | Settings | File Templates.
 */
package com.playfish.games.marlin.testing.performance.reporting.csv
{
    import com.playfish.games.marlin.testing.performance.capture.*;

    /**
     * Returns a string representation of the memory data for a particular test
     * @param target The target object for the test
     * @param testSet The name of the test set
     * @param includeHeader Whether to include a header in the CSV file
     * @return The encoded CSV
     */
    public function reportMemoryCSV(target:Object, testSet:String, includeHeader:Boolean):String
    {
        return retrieveTestSet(target, testSet).createMemoryCSV(true);
    }
}
