/**
 *
 */
package com.playfish.games.marlin.testing.performance.runner.async
{
    public class AsyncToken
    {
        private var _scope:Object;
        private var _onComplete:Function;
        private var _onError:Function;

        /**
         * Constructor
         * @param scope The scope of the async callbacks
         * @param onComplete The method to call on completion
         * @param onError The method to call on error
         */
        public function AsyncToken(scope:Object, onComplete:Function, onError:Function)
        {
            this._scope = scope;
            this._onComplete = onComplete;
            this._onError = onError;
        }

        /**
         * Call to notify that the test has completed
         */
        public function notifyComplete():void
        {
            _onComplete.call(_scope);
        }

        /**
         * Call to notify that the test has failed
         * @param msg The optional msg / error to pass
         */
        public function notifyFail(msg:* = null):void
        {
            if(msg == null)
            {
                _onError.call(_scope);
            }
            else
            {
                _onError.call(_scope, msg);
            }
        }
    }
}
