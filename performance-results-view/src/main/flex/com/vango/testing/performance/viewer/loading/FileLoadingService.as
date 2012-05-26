/**
 *
 */
package com.vango.testing.performance.viewer.loading
{
    import flash.data.SQLConnection;
    import flash.data.SQLMode;
    import flash.net.Responder;

    public class FileLoadingService
    {
        public function load(key:String = null):void
        {
            var path:String;
            if(key != null)
            {
                path = retrievePathForKey(key);
            }
            else
            {
                path = "";
            }

            trace("Loading path from '" + path + "'");
        }

        private function retrievePathForKey(key:String):String
        {
            var sql:SQLConnection = new SQLConnection();
            var responder:Responder = new Responder(onSuccess, onStatus);
            sql.open();
            sql.begin(SQLMode.CREATE, responder);
            return "";
        }

        private function onStatus():void
        {

        }

        private function onSuccess():void
        {

        }
    }
}
