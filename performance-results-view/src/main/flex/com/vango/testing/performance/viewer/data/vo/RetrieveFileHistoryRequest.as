/**
 *
 */
package com.vango.testing.performance.viewer.data.vo
{
    public class RetrieveFileHistoryRequest implements HistoryRequest
    {
        public function get ref():String
        {
            return _ref;
        }
        private var _ref:String;

        public function get callback():Function
        {
            return _callback;
        }
        private var _callback:Function;

        public function RetrieveFileHistoryRequest(ref:String, callback:Function)
        {
            _ref = ref;
            _callback = callback;
        }
    }
}
