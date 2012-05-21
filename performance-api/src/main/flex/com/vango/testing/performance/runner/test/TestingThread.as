/**
 *
 */
package com.vango.testing.performance.runner.test
{
    import com.vango.testing.performance.capture.retrieveTestSet;
    import com.vango.testing.performance.meta.configurations.IMethodConfiguration;
    import com.vango.testing.performance.runner.RunConfiguration;
    import com.vango.testing.performance.runner.RunPhase;
    import com.vango.testing.performance.runner.async.AsyncToken;
    import com.vango.testing.performance.runner.method.IMethodRunner;

    import flash.utils.Dictionary;
    import flash.utils.clearInterval;
    import flash.utils.getTimer;
    import flash.utils.setInterval;

    import org.osflash.signals.Signal;

    public class TestingThread
    {
        /**
         * If the thread is locked (ie running)
         */
        public function get isLocked():Boolean
        {
            return _isLocked;
        }
        private var _isLocked:Boolean;

        private var _testName:String;
        private var _context:ThreadContext;
        private var _configuration:RunConfiguration;

        private var _intervalId:int;
        private var _scope:Object;
        private var _currentMethodPhase:RunPhase;
        private var _currentMethodList:Vector.<IMethodConfiguration>;
        private var _currentMethodIndex:int;
        private var _callsRemaining:int;
        private var _methodDurations:Dictionary;
        private var _interval:int;
        private var _batchStartTime:int;
        private var _token:AsyncToken;
        private var _callInProgress:Boolean;

        internal var onTestCreated:Signal;

        /**
         * Starts the thread doing callbacks on the method
         * @param testName The name of the test that the thread is running
         * @param context The context to run the thread in
         * @param configuration The run configuration for the thread
         */
        public function start(testName:String, context:ThreadContext, configuration:RunConfiguration):void
        {
            if(isLocked)
            {
                throw new Error("The test thread is already running");
            }
            _isLocked = true;

            // store params
            this._testName = testName;
            this._context = context;
            this._configuration = configuration;

            // create async token
            _token = new AsyncToken(this, onCallComplete, onCallFailed);

            // reset counters
            _methodDurations = new Dictionary();
            _currentMethodPhase = RunPhase.BEFORE;
            _currentMethodList = _configuration.getMethodsByPhase(_currentMethodPhase);
            _currentMethodIndex = 0;
            _callsRemaining = _context.callCount;
            _scope = _configuration.createNewTestObject();
            if(onTestCreated != null)
            {
                onTestCreated.dispatch(_scope);
            }
            _intervalId = setInterval(runNextBatch, 1);
        }

        /**
         * Stops the thread from running
         */
        public function stop():void
        {
            _isLocked = false;
            _callInProgress = false;
            clearInterval(_intervalId);
            _intervalId = -1;
        }

        /**
         * Destroys the thread
         */
        public function destroy():void
        {
            _methodDurations = null;
            _configuration = null;
            _context = null;
            _scope = null;
            onTestCreated = null;
            clearInterval(_intervalId);
            _intervalId = -1;
        }

        /**
         * Runs the next batch of tests
         */
        private function runNextBatch():void
        {
            if(_callsRemaining == 0)
            {
                completeWork();
            }
            else
            {
                _interval = _context.interval;
                _batchStartTime = getTimer();
                while (!_callInProgress && (_callsRemaining > 0) && (getTimer() - _batchStartTime) < _interval)
                {
                    var methodConfigClass:Class = (_currentMethodList[_currentMethodIndex] as Object).constructor;
                    var methodRunner:IMethodRunner = _context.runnerMap.getMethodRunner(methodConfigClass);
                    _callInProgress = true;
                    methodRunner.execute(_configuration.testClass, _testName, _scope, _currentMethodList[_currentMethodIndex], _token);
                }
            }
        }

        /**
         * Handles call completion
         */
        private function onCallComplete():void
        {
            _callInProgress = false;
            _currentMethodIndex++;
            if (_currentMethodIndex >= _currentMethodList.length)
            {
                _currentMethodIndex = 0;
                _currentMethodPhase = RunPhase.nextPhase(_currentMethodPhase);
                if (_currentMethodPhase == RunPhase.END)
                {
                    _currentMethodPhase = RunPhase.nextPhase(_currentMethodPhase);
                    _callsRemaining--;

                    // if there are still calls remaining
                    if (_callsRemaining > 0)
                    {
                        // for debug purposes. This allows the object being tested to be gathered
                        _scope = _configuration.createNewTestObject();
                        // dispatch test created
                        if (onTestCreated != null)
                        {
                            onTestCreated.dispatch(_scope);
                        }
                    }
                }
                _currentMethodList = _configuration.getMethodsByPhase(_currentMethodPhase);
            }
        }

        /**
         * Handles call failure
         */
        private function onCallFailed(msg:* = null):void
        {
            stop();
            _context.onFailedCallback(msg);
        }

        /**
         * Call to complete the threads work
         */
        private function completeWork():void
        {
            clearInterval(_intervalId);
            _intervalId = -1;
            _isLocked = false;
            _context.onCompleteCallback(retrieveTestSet(_configuration.testClass, _testName));
        }
    }
}
