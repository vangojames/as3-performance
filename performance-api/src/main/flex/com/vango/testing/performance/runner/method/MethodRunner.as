/**
 *
 */
package com.vango.testing.performance.runner.method
{
    import com.vango.testing.performance.meta.configurations.IMethodConfiguration;
    import com.vango.testing.performance.runner.async.AsyncToken;

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
