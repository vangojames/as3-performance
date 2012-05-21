/**
 *
 */
package com.vango.testing.performance.runner.method
{
    import com.vango.testing.performance.capture.takeSnapshot;
    import com.vango.testing.performance.meta.configurations.IMethodConfiguration;
    import com.vango.testing.performance.runner.async.AsyncToken;

    import flash.system.System;
    import flash.utils.getTimer;

    public class SnapshotMethodRunner implements IMethodRunner
    {
        private var _method:Function;
        private var _mem:int;
        private var _time:int;

        /**
         * @inheritDoc
         */
        public function execute(testClass:Class, testName:String, scope:Object, configuration:IMethodConfiguration, token:AsyncToken):void
        {
            // get the method to call
            _method = scope[configuration.methodName];
            // force garbage collection
            System.gc();
            _mem = System.totalMemory;
            _time = getTimer();
            _method();
            takeSnapshot(testClass, testName, configuration.methodName, getTimer() - _time, System.totalMemory - _mem);
            token.notifyComplete();
        }
    }
}
