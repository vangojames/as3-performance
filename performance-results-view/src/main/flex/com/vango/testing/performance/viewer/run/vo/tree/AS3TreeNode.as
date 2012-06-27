/**
 *
 */
package com.vango.testing.performance.viewer.run.vo.tree
{
    import flash.filesystem.File;

    public class AS3TreeNode
    {
        public var name:String;
        public var parent:AS3TreeNode;
        public var relativeName:String;

        public function get nativeLocation():File { return _nativeLocation; }
        public function set nativeLocation(value:File):void
        {
            _nativeLocation = value;
            _nativePath = _nativeLocation.nativePath;
        }
        private var _nativeLocation:File;

        public function get nativePath():String
        {
            return _nativePath;
        }
        private var _nativePath:String;
    }
}
