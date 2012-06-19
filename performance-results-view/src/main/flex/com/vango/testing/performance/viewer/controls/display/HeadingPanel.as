/**
 *
 */
package com.vango.testing.performance.viewer.controls.display
{
    import com.vango.testing.performance.viewer.controls.commands.ControlID;
    import com.vango.testing.performance.viewer.controls.vo.ControlContext;

    import mx.collections.ArrayCollection;
    import mx.collections.IList;

    import spark.components.Group;
    import spark.events.IndexChangeEvent;

    public class HeadingPanel extends Group
    {
        [Bindable]
        public var selectedItem:ControlID;

        public var controls:IList = new ArrayCollection();

        public function HeadingPanel()
        {
            // create the relevant control contexts
            controls.addItem(createControlContext("Run", ControlID.RUN));
            controls.addItem(createControlContext("Profile", ControlID.PROFILE));
            controls.addItem(createControlContext("Compare", ControlID.COMPARE));
        }

        private function createControlContext(label:String, command:ControlID):ControlContext
        {
            var controlContext:ControlContext = new ControlContext();
            controlContext.label = label;
            controlContext.command = command;
            return controlContext;
        }

        protected function onControlItemSelected(event:IndexChangeEvent):void
        {
            if(event.newIndex >= 0)
            {
                var context:ControlContext = controls[event.newIndex];
                selectedItem = context.command;
            }
        }
    }
}
