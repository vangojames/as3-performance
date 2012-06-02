/**
 *
 */
package com.vango.testing.performance.viewer.io.vo
{
    import flash.filesystem.File;

    public class FileBrowsingConfig
    {
        public var initialFile:File;
        public var windowTitle:String;
        public var typeFilter:Array;
        public var callback:Function;

        public function FileBrowsingConfig(initialFile:File, windowTitle:String, fileFilter:Array, callback:Function)
        {
            if(callback.length != 1)
            {
                throw new Error("Expected file browsing callback to take one parameter of type 'File'");
            }
            this.initialFile = initialFile;
            this.windowTitle = windowTitle;
            this.typeFilter = fileFilter;
            this.callback = callback;
        }
    }
}
