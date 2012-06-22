/**
 *
 */
package com.vango.testing.performance.viewer.run.vo
{
    import com.vango.testing.performance.viewer.data.vo.FileEntry;

    import flash.filesystem.File;

    import mx.collections.ArrayCollection;

    public class VerificationResult
    {
        public var target:FileEntry;
        public var success:Boolean;
        public var msg:String = "";
        public var fileList:XML;
    }
}
