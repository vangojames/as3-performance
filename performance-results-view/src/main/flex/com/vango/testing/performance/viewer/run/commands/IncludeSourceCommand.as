/**
 *
 */
package com.vango.testing.performance.viewer.run.commands
{
    import com.vango.testing.performance.viewer.run.proxies.TestRunProxy;

    import flash.filesystem.File;

    import org.robotlegs.mvcs.SignalCommand;

    public class IncludeSourceCommand extends SignalCommand
    {
        [Inject]
        public var runProxy:TestRunProxy;
        [Inject]
        public var file:File;

        override public function execute():void
        {
            runProxy.includeSource(file);
        }
    }
}
