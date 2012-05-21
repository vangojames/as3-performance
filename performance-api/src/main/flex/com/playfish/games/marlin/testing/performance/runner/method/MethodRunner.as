/**
 *
 */
package com.playfish.games.marlin.testing.performance.runner.method
{
    import com.playfish.games.marlin.testing.performance.meta.configurations.IMethodConfiguration;
    import com.playfish.games.marlin.testing.performance.runner.async.AsyncToken;

    public class MethodRunner implements IMethodRunner
    {
        /**
         * @inheritDoc
         */
        public function execute(testClass:Class, testName:String, scope:Object, configuration:IMethodConfiguration, token:AsyncToken):void
        {
            // get the method to call
            scope[configuration.methodName]();
            token.notifyComplete();
        }
    }
}
