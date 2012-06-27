/**
 *
 */
package com.vango.testing.performance.viewer.run.vo.context
{
    public class ContextMenuCommand
    {
        private var _callback:Function;
        private var _argList:Array;

        public function ContextMenuCommand(callback:Function, ...arguments)
        {
            _callback = callback;

            var l:int = arguments.length;
            _argList = new Array(l);
            for(var i:int = 0; i < l; i++)
            {
                _argList[i] = arguments[i];
            }
        }

        public function execute():void
        {
            _callback.apply(undefined, _argList);
        }
    }
}
