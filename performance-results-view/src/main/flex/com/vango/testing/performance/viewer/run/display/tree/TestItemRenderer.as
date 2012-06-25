package com.vango.testing.performance.viewer.run.display.tree
{
    import com.vango.testing.performance.viewer.run.vo.AS3File;
    import com.vango.testing.performance.viewer.run.vo.AS3TreeNode;

    import flash.events.MouseEvent;

    import mx.binding.utils.BindingUtils;
    import mx.controls.CheckBox;
    import mx.controls.treeClasses.*;

    public class TestItemRenderer extends TreeItemRenderer
    {
        public var chk:CheckBox;
        public var itemData:AS3TreeNode;

        [Bindable]
        public var file:AS3File;

        public function TestItemRenderer()
        {
            super();
            mouseEnabled = false;
        }

        override public function set data(value:Object):void
        {
            if (value != null)
            {
                super.data = value;

                this.itemData = AS3TreeNode(value);

                if(itemData.isTest)
                {
                    chk.visible = true;
                    chk.selected = itemData.file.isSelected;
                    BindingUtils.bindProperty(itemData.file, "isSelected", chk, "selected", false, true);
                    BindingUtils.bindProperty(chk, "selected", itemData.file, "isSelected", false, true);
                }
                else
                {
                    chk.visible = false;
                }
            }
        }

        override protected function createChildren():void
        {
            super.createChildren();
            chk = new CheckBox();
            chk.addEventListener(MouseEvent.CLICK, handleChkClick);
            addChild(chk);
        }

        override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void
        {
            super.updateDisplayList(unscaledWidth, unscaledHeight);
            if (super.data)
            {
                var tld:TreeListData = TreeListData(super.listData);
                //In some cases you only want a checkbox to appear if an
                //item is a leaf
                //if so, then keep the following block uncommented,
                //otherwise you can comment it out to display the checkbox
                //for branch nodes
                if (tld.hasChildren)
                {
                    this.chk.visible = false;
                }
                else
                {
                    //You HAVE to have the else case to set visible to true
                    //even though you'd think the default would be visible
                    //it's an issue with itemrenderers...
                    if(itemData && itemData.isTest)
                    {
                        this.chk.visible = true;
                    }
                    else
                    {
                        this.chk.visible = false;
                    }
                }
                if (chk.visible)
                {
                    //if the checkbox is visible then
                    //reposition the controls to make room for checkbox
                    this.chk.x = super.label.x
                    super.label.x = this.chk.x + 17;
                    this.chk.y = super.label.y + 8;
                }
            }
        }

        private function handleChkClick(evt:MouseEvent):void
        {
            itemData.file.isSelected = chk.selected;
        }
    }
}