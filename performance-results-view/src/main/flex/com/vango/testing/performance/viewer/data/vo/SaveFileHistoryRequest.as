/**
 *
 */
package com.vango.testing.performance.viewer.data.vo
{
    import flash.filesystem.File;

    public class SaveFileHistoryRequest implements HistoryRequest
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

        public function get file():File
        {
            return _file;
        }
        private var _file:File;

        public function SaveFileHistoryRequest(ref:String, callback:Function, file:File)
        {
            _ref = ref;
            _callback = callback;
            _file = file;
        }
    }
}
