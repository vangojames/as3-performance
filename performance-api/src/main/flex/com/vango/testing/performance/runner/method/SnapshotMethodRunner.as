/**
 *
 */
package com.vango.testing.performance.runner.method
{
    import com.vango.testing.performance.capture.takeSnapshot;
    import com.vango.testing.performance.meta.configurations.IMethodConfiguration;
    import com.vango.testing.performance.runner.async.AsyncToken;

    import flash.events.UncaughtErrorEvent;

    import flash.events.UncaughtErrorEvents;

    import flash.system.System;
    import flash.utils.getTimer;

    public class SnapshotMethodRunner implements IMethodRunner
    {
        private var _method:Function;
        private var _mem:int;
        private var _time:int;

        private var _token:AsyncToken;

        private var _uncaughtErrors:UncaughtErrorEvents;

        public function SnapshotMethodRunner(uncaughtErrors:UncaughtErrorEvents)
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
            _method = scope[configuration.methodName];
            // force garbage collection
            System.gc();
            _mem = System.totalMemory;
            _time = getTimer();
            addErrorHandling();
            _method();
            removeErrorHandling();
            takeSnapshot(testClass, testName, configuration.methodName, getTimer() - _time, System.totalMemory - _mem);
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
