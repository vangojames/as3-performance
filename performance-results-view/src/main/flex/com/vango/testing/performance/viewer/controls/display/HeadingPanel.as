/**
 *
 */
package com.vango.testing.performance.viewer.controls.display
{
    import com.vango.testing.performance.viewer.controls.commands.ControlCommandId;
    import com.vango.testing.performance.viewer.controls.vo.ControlContext;

    import mx.collections.ArrayCollection;
    import mx.collections.IList;

    import org.osflash.signals.Signal;

    import spark.components.Group;
    import spark.events.IndexChangeEvent;

    public class HeadingPanel extends Group
    {
        public const onControlSelected:Signal = new Signal(ControlContext);

        public var controls:IList = new ArrayCollection();

        public function HeadingPanel()
        {
            // create the relevant control contexts
            createControlContext("Run Tests...", ControlCommandId.RUN_TESTS);
        }

        private function createControlContext(label:String, commandName:String):void
        {
            var controlContext:ControlContext = new ControlContext();
            controlContext.label = label;
            controlContext.commandName = commandName;
            controls.addItem(controlContext);
        }

        protected function onControlItemSelected(event:IndexChangeEvent):void
        {
            if(event.newIndex >= 0)
            {
                var context:ControlContext = controls[event.newIndex];
                onControlSelected.dispatch(context);
            }
        }
    }
}
