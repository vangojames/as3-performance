/**
 *
 */
package com.vango.testing.performance.runner.test
{
    import com.vango.testing.performance.runner.method.MethodRunnerMap;

    public class ThreadContext
    {
        public function get callCount():int
        {
            return _callCount;
        }

        public function set callCount(value:int):void
        {
            _callCount = value;
        }
        private var _callCount:int;

        public function get onCompleteCallback():Function
        {
            return _onCompleteCallback;
        }

        public function set onCompleteCallback(value:Function):void
        {
            _onCompleteCallback = value;
        }
        private var _onCompleteCallback:Function;

        public function get onFailedCallback():Function
        {
            return _onFailedCallback;
        }

        public function set onFailedCallback(value:Function):void
        {
            _onFailedCallback = value;
        }
        private var _onFailedCallback:Function;

        public function get interval():int
        {
            return _interval;
        }

        public function set interval(value:int):void
        {
            _interval = value;
        }
        private var _interval:int;

        /**
         * The map from configuration to runner type
         */
        public function get runnerMap():MethodRunnerMap
        {
            return _runnerMap;
        }

        public function set runnerMap(value:MethodRunnerMap):void
        {
            _runnerMap = value;
        }
        private var _runnerMap:MethodRunnerMap;

        public function ThreadContext(callCount:int, interval:int, completeCallback:Function, failCallback:Function, runnerMap:MethodRunnerMap)
        {
            this.callCount = callCount;
            this.interval = interval;
            this.onCompleteCallback = completeCallback;
            this.onFailedCallback = failCallback;
            this._runnerMap = runnerMap;
        }
    }
}
