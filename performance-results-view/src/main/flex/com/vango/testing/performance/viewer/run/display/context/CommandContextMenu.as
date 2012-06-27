/**
 *
 */
package com.vango.testing.performance.viewer.run.display.context
{
    import com.vango.testing.performance.viewer.run.vo.context.ContextMenuCommand;

    import flash.display.NativeMenu;
    import flash.display.NativeMenuItem;
    import flash.events.Event;
    import flash.utils.Dictionary;

    public class CommandContextMenu extends NativeMenu
    {
        private var _menuItemToCommand:Dictionary = new Dictionary();

        /**
         * Adds a command driven menu item
         */
        public function addCommandMenuItem(label:String, command:ContextMenuCommand, index:int = -1):void
        {
            var menuItem:NativeMenuItem = new NativeMenuItem(label);
            _menuItemToCommand[menuItem] = command;
             menuItem.addEventListener(Event.SELECT, onItemSelected);
            if(index >= 0)
            {
                addItemAt(menuItem, index);
            }
            else
            {
                addItem(menuItem);
            }
        }

        /**
         * Handles item selection
         */
        private function onItemSelected(event:Event):void
        {
            var item:NativeMenuItem = event.currentTarget as NativeMenuItem;
            if(item.enabled)
            {
                try
                {
                    (_menuItemToCommand[item] as ContextMenuCommand).execute();
                }
                catch(er:Error)
                {
                    trace("Error executing context menu function : " + er);
                }
            }
        }
    }
}
