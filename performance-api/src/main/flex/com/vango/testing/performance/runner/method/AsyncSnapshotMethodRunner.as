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
    import flash.utils.getQualifiedClassName;
    import flash.utils.getTimer;

    public class AsyncSnapshotMethodRunner
    {
        private var _testClass:Class;
        private var _testName:String;
        private var _methodName:String;
        private var _scope:Object;
        private var _token:AsyncToken;
        private var _method:Function;
        private var _mem:int;
        private var _time:int;

        private var _uncaughtErrors:UncaughtErrorEvents;

        public function AsyncSnapshotMethodRunner(uncaughtErrors:UncaughtErrorEvents)
        {
            _uncaughtErrors = uncaughtErrors;
        }

        /**
         * @inheritDoc
         */
        public function execute(testClass:Class, testName:String, scope:Object, configuration:IMethodConfiguration, token:AsyncToken):void
        {
            this._testClass = testClass;
            this._testName = testName;
            this._methodName = configuration.methodName;
            this._scope = scope;
            this._token = token;

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
                _method = scope[configuration.methodName];
                // force garbage collection
                System.gc();
                _mem = System.totalMemory;
                _time = getTimer();
                addErrorHandling();
                _method(onComplete, onFail);
            }
        }

        private function onComplete():void
        {
            removeErrorHandling();
            takeSnapshot(_testClass, _testName, _methodName, getTimer() - _time, System.totalMemory - _mem);
            _token.notifyComplete();
        }

        private function onFail(msg:* = null):void
        {
            removeErrorHandling();
            _token.notifyFail(msg);
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
