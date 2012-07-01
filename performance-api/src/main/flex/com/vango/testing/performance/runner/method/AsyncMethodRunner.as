/**
 *
 */
package com.vango.testing.performance.runner.method
{
    import com.vango.testing.performance.meta.configurations.IMethodConfiguration;
    import com.vango.testing.performance.runner.async.AsyncToken;

    import flash.events.UncaughtErrorEvent;

    import flash.events.UncaughtErrorEvents;

    import flash.utils.getQualifiedClassName;

    public class AsyncMethodRunner implements IMethodRunner
    {
        private var _token:AsyncToken;
        private var _uncaughtErrors:UncaughtErrorEvents;

        public function AsyncMethodRunner(uncaughtErrors:UncaughtErrorEvents)
        {
            _uncaughtErrors = uncaughtErrors;
        }

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
                this._token = token;
                addErrorHandling();
                // get the method to call
                scope[configuration.methodName](token.notifyComplete, token.notifyFail);
                removeErrorHandling();
            }
        }

        private function addErrorHandling():void
        {
            if(_uncaughtErrors)
            {
                _uncaughtErrors.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);
            }
        }

        private function removeErrorHandling():void
        {
            if(_uncaughtErrors)
            {
                _uncaughtErrors.removeEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);
            }
        }

        private function onUncaughtError(event:UncaughtErrorEvent):void
        {
            _uncaughtErrors.removeEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, onUncaughtError);
            _token.notifyFail(event.error);
        }
    }
}
