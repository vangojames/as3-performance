/**
 *
 */
package com.vango.testing.performance.runner.method
{
    import com.vango.testing.performance.meta.configurations.IMethodConfiguration;
    import com.vango.testing.performance.runner.async.AsyncToken;

    import flash.utils.getQualifiedClassName;

    public class AsyncMethodRunner implements IMethodRunner
    {
        /**
         * @inheritDoc
         */
        public function execute(testClass:Class, testName:String, scope:Object, configuration:IMethodConfiguration, token:AsyncToken):void
        {
            if(scope == null)
            {
                token.notifyFail("Scope cannot be null");
            }
            else if(!scope.hasOwnProperty(configuration.methodName))
            {
                token.notifyFail("Unrecognised method '" + configuration.methodName + "' on object '" + getQualifiedClassName(scope) + "'")
            }
            else
            {
                // get the method to call
                scope[configuration.methodName](token.notifyComplete, token.notifyFail);
            }
        }
    }
}
