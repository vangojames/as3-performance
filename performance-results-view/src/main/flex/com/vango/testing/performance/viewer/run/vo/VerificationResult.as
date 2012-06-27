/**
 *
 */
package com.vango.testing.performance.viewer.run.vo
{
    import com.vango.testing.performance.viewer.data.vo.FileEntry;
    import com.vango.testing.performance.viewer.run.vo.tree.AS3TreeFolder;

    import mx.collections.ArrayCollection;

    public class VerificationResult
    {
        public var target:FileEntry;
        public var success:Boolean;
        public var msg:String = "";
        public var sourceTree:AS3TreeFolder;
        public var testList:ArrayCollection;
        public var sourceList:ArrayCollection;
    }
}
