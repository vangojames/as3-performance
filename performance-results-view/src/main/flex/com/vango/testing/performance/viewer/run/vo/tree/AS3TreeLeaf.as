/**
 *
 */
package com.vango.testing.performance.viewer.run.vo.tree
{
    import flash.filesystem.File;

    public class AS3TreeLeaf extends AS3TreeNode
    {
        [Bindable]
        public var isSelected:Boolean = true;
        public var sourceRoot:File;
        public var packageName:String;
    }
}
