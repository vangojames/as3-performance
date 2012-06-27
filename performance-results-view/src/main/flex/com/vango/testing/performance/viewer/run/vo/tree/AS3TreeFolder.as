/**
 *
 */
package com.vango.testing.performance.viewer.run.vo.tree
{
    import flash.filesystem.File;
    import flash.utils.Dictionary;

    import mx.collections.ArrayCollection;

    public class AS3TreeFolder extends AS3TreeNode
    {
        public var children:ArrayCollection;
        public var containsTest:Boolean;
        public var containsSource:Boolean;

        private var _nodes:Dictionary = new Dictionary();

        public function AS3TreeFolder(name:String, location:File, children:ArrayCollection)
        {
            this.name = name;
            this.nativeLocation = location;
            this.children = children;
        }

        public function addNode(node:AS3TreeNode):void
        {
            _nodes[getKey(node.name)] = node;
            children.addItem(node);
            node.parent = this;
        }

        public function getNode(name:String):AS3TreeNode
        {
            return _nodes[getKey(name)];
        }

        public function contains(name:String):Boolean
        {
            return _nodes[getKey(name)] != null;
        }

        private function getKey(name:String):String
        {
            return "$" + name;
        }
    }
}
