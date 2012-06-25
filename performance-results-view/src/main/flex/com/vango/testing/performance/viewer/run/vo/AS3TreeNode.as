/**
 *
 */
package com.vango.testing.performance.viewer.run.vo
{
    import flash.utils.Dictionary;

    import mx.collections.ArrayCollection;

    public class AS3TreeNode
    {
        public var name:String;
        public var nativePath:String;
        public var parent:AS3TreeNode;
        public var children:ArrayCollection;
        public var isTest:Boolean;
        public var containsTest:Boolean;
        public var relativeName:String;
        public var file:AS3File;

        private var _nodes:Dictionary = new Dictionary();

        public function AS3TreeNode(name:String, nativePath:String, children:ArrayCollection, file:AS3File = null)
        {
            this.name = name;
            this.nativePath = nativePath;
            this.children = children;
            this.file = file;
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
