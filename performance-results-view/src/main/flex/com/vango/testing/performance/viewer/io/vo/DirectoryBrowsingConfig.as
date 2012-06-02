/**
 *
 */
package com.vango.testing.performance.viewer.io.vo
{
    import flash.filesystem.File;

    public class DirectoryBrowsingConfig
    {
        public var initialFile:File;
        public var windowTitle:String;
        public var callback:Function;

        public function DirectoryBrowsingConfig(initialFile:File, windowTitle:String, callback:Function)
        {
            if(callback.length != 1)
            {
                throw new Error("Expected directory browsing callback to take one parameter of type 'File'");
            }
            this.initialFile = initialFile;
            this.windowTitle = windowTitle;
            this.callback = callback;
        }
    }
}
