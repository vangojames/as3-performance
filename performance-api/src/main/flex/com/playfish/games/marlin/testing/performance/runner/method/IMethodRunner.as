/**
 *
 */
package com.playfish.games.marlin.testing.performance.runner.method
{
    import com.playfish.games.marlin.testing.performance.meta.configurations.IMethodConfiguration;
    import com.playfish.games.marlin.testing.performance.runner.async.AsyncToken;

    public interface IMethodRunner
    {
        /**
         * Executes a method
         * @param testClass The current test class
         * @param testName The name of the test class
         * @param scope The scope to run in
         * @param configuration the method configuration
         */
        function execute(testClass:Class, testName:String, scope:Object, configuration:IMethodConfiguration, token:AsyncToken):void;
    }
}
