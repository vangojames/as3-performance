/**
 *
 */
package com.vango.testing.performance.runner.method
{
    import com.vango.testing.performance.meta.configurations.IMethodConfiguration;
    import com.vango.testing.performance.runner.async.AsyncToken;

    import flash.events.UncaughtErrorEvent;

    import flash.events.UncaughtErrorEvents;

    public class MethodRunner implements IMethodRunner
    {
        private var _uncaughtErrors:UncaughtErrorEvents;
        private var _token:AsyncToken;

        public function MethodRunner(uncaughtErrors:UncaughtErrorEvents)
        {
            _uncaughtErrors = uncaughtErrors;
        }

        /**
         * @inheritDoc
         */
        public function execute(testClass:Class, testName:String, scope:Object, configuration:IMethodConfiguration, token:AsyncToken):void
        {
            this._token = token;
            // get the method to call
            addErrorHandling();
            scope[configuration.methodName]();
            removeErrorHandling();
            token.notifyComplete();
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
