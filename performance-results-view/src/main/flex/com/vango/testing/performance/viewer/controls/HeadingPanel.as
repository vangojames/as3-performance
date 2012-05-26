/**
 *
 */
package com.vango.testing.performance.viewer.controls
{
    import com.vango.testing.performance.viewer.loading.InitialiseTestLoadingCommand;

    import mx.collections.ArrayCollection;
    import mx.collections.IList;

    import spark.components.Group;
    import spark.events.IndexChangeEvent;

    public class HeadingPanel extends Group
    {
        public var controls:IList = new ArrayCollection();

        public function HeadingPanel()
        {
            // create the relevant control contexts
            createControlContext("Run Tests...", new InitialiseTestLoadingCommand());
        }

        private function createControlContext(label:String, command:IControlCommand):void
        {
            var controlContext:ControlContext = new ControlContext();
            controlContext.label = label;
            controlContext.command = command;
            controls.addItem(controlContext);
        }

        protected function onControlItemSelected(event:IndexChangeEvent):void
        {
            var context:ControlContext = controls[event.newIndex];
            context.command.execute();
        }
    }
}
