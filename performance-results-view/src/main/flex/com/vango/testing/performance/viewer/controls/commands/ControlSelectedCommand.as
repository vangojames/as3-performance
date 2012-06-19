/**
 *
 */
package com.vango.testing.performance.viewer.controls.commands
{
    import com.vango.testing.performance.viewer.controls.vo.ControlContext;

    import org.robotlegs.mvcs.Command;
    import org.robotlegs.mvcs.SignalCommand;

    public class ControlSelectedCommand extends SignalCommand
    {
        [Inject]
        public var controlContext:ControlContext;

        override public function execute():void
        {
            // execute the command associated with the control
            var command:Command = injector.getInstance(Command, controlContext.command.name);
            command.execute();
        }
    }
}
