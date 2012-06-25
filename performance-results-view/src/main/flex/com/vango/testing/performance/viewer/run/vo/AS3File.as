/**
 *
 */
package com.vango.testing.performance.viewer.run.vo
{
    import flash.filesystem.File;

    public class AS3File
    {
        public var name:String;
        public var location:File;
        public var sourceRoot:File;
        public var isTest:Boolean;
        public var packageName:String;
        [Bindable]
        public var isSelected:Boolean = true;
    }
}
