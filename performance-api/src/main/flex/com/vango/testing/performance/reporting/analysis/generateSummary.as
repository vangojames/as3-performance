package com.vango.testing.performance.reporting.analysis
{
    import com.vango.testing.performance.capture.retrieveTestSet;

    /**
     * Generates a summary of the test testing for the specified test
     * @param target The target being tested
     * @param testSet The test set to generate for
     */
    public function generateSummary(target:Object, testSet:String):TestSetSummary
    {
        var summary:TestSetSummary = new TestSetSummary();
        summary.summarise(retrieveTestSet(target, testSet));
        return summary;
    }
}
