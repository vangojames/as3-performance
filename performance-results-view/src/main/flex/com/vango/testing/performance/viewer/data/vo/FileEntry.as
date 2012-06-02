/**
 *
 */
package com.vango.testing.performance.viewer.data.vo
{
    import org.osflash.spod.SpodObject;

    public class FileEntry extends SpodObject
    {
        [Type(name="uid", identifier="true")]
        public var id:int;
        [Type(name="ref")]
        public var ref:String;
        [Type(name="path")]
        public var path:String;
        [Type(name="accessTime")]
        public var accessTime:int;
    }
}
