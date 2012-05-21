/**
 * Created with IntelliJ IDEA.
 * User: jvango
 * Date: 29/04/12
 * Time: 21:51
 * To change this template use File | Settings | File Templates.
 */
package com.vango.testing.performance.reporting.csv
{
    import com.vango.testing.performance.capture.retrieveTestSet;

    /**
     * Returns a string representation of the testing data for a particular test
     * @param target The target object for the test
     * @param testSet The name of the test set
     * @param includeHeader Whether to include a header in the CSV file
     * @return The encoded CSV
     */
    public function reportPerformanceCSV(target:Object, testSet:String, includeHeader:Boolean):String
    {
        return retrieveTestSet(target, testSet).createPerformanceCSV(includeHeader);
    }
}
