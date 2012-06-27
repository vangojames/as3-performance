package com.vango.testing.performance.viewer.run.display.tree
{
    import com.vango.testing.performance.viewer.run.display.context.CommandContextMenu;
    import com.vango.testing.performance.viewer.run.vo.context.ContextMenuCommand;
    import com.vango.testing.performance.viewer.run.vo.tree.AS3TreeFolder;
    import com.vango.testing.performance.viewer.run.vo.tree.AS3TreeLeaf;
    import com.vango.testing.performance.viewer.run.vo.tree.AS3TreeNode;
    import com.vango.testing.performance.viewer.run.vo.tree.AS3TreeSource;
    import com.vango.testing.performance.viewer.run.vo.tree.AS3TreeTest;

    import flash.events.MouseEvent;

    import mx.binding.utils.BindingUtils;
    import mx.controls.CheckBox;
    import mx.controls.Tree;
    import mx.controls.treeClasses.*;

    public class TestItemRenderer extends TreeItemRenderer
    {
        override public function set data(value:Object):void
        {
            if (value != null)
            {
                super.data = value;

                this.itemData = AS3TreeNode(value);

                if(itemData is AS3TreeLeaf)
                {
                    var leaf:AS3TreeLeaf = itemData as AS3TreeLeaf;
                    chk.visible = true;
                    chk.selected = leaf.isSelected;
                    BindingUtils.bindProperty(leaf, "isSelected", chk, "selected", false, true);
                    BindingUtils.bindProperty(chk, "selected", leaf, "isSelected", false, true);
                }
                else
                {
                    var folder:AS3TreeFolder = itemData as AS3TreeFolder;
                    contextMenu = null;
                    chk.visible = false;
                }

                buildContextMenu();
            }
        }

        public var chk:CheckBox;
        public var itemData:AS3TreeNode;

        public function TestItemRenderer()
        {
            super();
            mouseEnabled = false;
            addEventListener("contextMenu", onContextMenuOpen);
        }

        override protected function createChildren():void
        {
            super.createChildren();
            chk = new CheckBox();
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
                    if(itemData)
                    {
                        if(itemData is AS3TreeLeaf)
                        {
                            this.chk.visible = true;
                            if(itemData is AS3TreeTest)
                            {
                                label.textColor = 0x006600;
                            }
                            else
                            {
                                label.textColor = 0x000066;
                            }
                        }
                        else
                        {
                            this.chk.visible = false;
                        }
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

        private function onContextMenuOpen(event:MouseEvent):void
        {
            // select the item
            if(listData)
            {
                (listData.owner as Tree).selectedItem = data;
            }
        }

        private function buildContextMenu():void
        {
            var customContextMenu:CommandContextMenu = new CommandContextMenu();
            if(data is AS3TreeLeaf)
            {
                if(data is AS3TreeTest)
                {
                    customContextMenu.addCommandMenuItem("Include test", new ContextMenuCommand(updateItemSelection, true, isTest));
                    customContextMenu.addCommandMenuItem("Exclude test", new ContextMenuCommand(updateItemSelection, false, isTest));
                }
                else
                {
                    customContextMenu.addCommandMenuItem("Include source", new ContextMenuCommand(updateItemSelection, true, isSource));
                    customContextMenu.addCommandMenuItem("Exclude source", new ContextMenuCommand(updateItemSelection, false, isSource));
                }
            }
            else
            {
                var folder:AS3TreeFolder = data as AS3TreeFolder;

                if(folder.containsTest && folder.containsSource)
                {
                    customContextMenu.addCommandMenuItem("Include all", new ContextMenuCommand(updateChildItemSelections, true, null));
                    customContextMenu.addCommandMenuItem("Exclude all", new ContextMenuCommand(updateChildItemSelections, false, null));
                }
                if(folder.containsTest)
                {
                    var testMenu:CommandContextMenu = new CommandContextMenu();
                    customContextMenu.addSubmenu(testMenu, "Tests");
                    testMenu.addCommandMenuItem("Include all", new ContextMenuCommand(updateChildItemSelections, true, isTest));
                    testMenu.addCommandMenuItem("Exclude all", new ContextMenuCommand(updateChildItemSelections, false, isTest));
                }
                if(folder.containsSource)
                {
                    var sourceMenu:CommandContextMenu = new CommandContextMenu();
                    customContextMenu.addSubmenu(sourceMenu, "Sources");
                    sourceMenu.addCommandMenuItem("Include all", new ContextMenuCommand(updateChildItemSelections, true, isSource));
                    sourceMenu.addCommandMenuItem("Exclude all", new ContextMenuCommand(updateChildItemSelections, false, isSource));
                }
            }

            this.contextMenu = customContextMenu;
        }

        /**
         * Selects the item
         */
        private function updateItemSelection(isSelected:Boolean, filter:Function):void
        {
            if(itemData)
            {
                var leaf:AS3TreeLeaf = itemData as AS3TreeLeaf;
                if(filter != null)
                {
                    if(filter(itemData))
                    {
                        leaf.isSelected = isSelected;
                    }
                }
                else
                {
                    leaf.isSelected = isSelected;
                }
            }
        }

        /**
         * Selects the item
         */
        private function updateChildItemSelections(isSelected:Boolean, filter:Function):void
        {
            if(itemData)
            {
                setChildSelections(itemData, isSelected, filter);
            }
        }

        private function setChildSelections(itemData:AS3TreeNode, isSelected:Boolean, filter:Function):void
        {
            if(itemData is AS3TreeFolder)
            {
                var folder:AS3TreeFolder = itemData as AS3TreeFolder;
                var l:int = folder.children.length;
                for(var i:int = 0; i < l; i++)
                {
                    var child:AS3TreeNode = folder.children.getItemAt(i) as AS3TreeNode;
                    setChildSelections(child, isSelected, filter);
                }
            }
            else
            {
                var leaf:AS3TreeLeaf = itemData as AS3TreeLeaf;
                if(filter != null)
                {
                    if(filter(itemData))
                    {
                        leaf.isSelected = isSelected;
                    }
                }
                else
                {
                    leaf.isSelected = isSelected;
                }
            }
        }

        private function isTest(node:AS3TreeLeaf):Boolean
        {
            return node is AS3TreeTest;
        }

        private function isSource(node:AS3TreeLeaf):Boolean
        {
            return node is AS3TreeSource;
        }
    }
}