/**
 *
 */
package
{
    import com.vango.testing.performance.viewer.controls.InstallControls;
    import com.vango.testing.performance.viewer.data.InstallData;
    import com.vango.testing.performance.viewer.init.commands.InitialiseApplicationCommand;
    import com.vango.testing.performance.viewer.init.signals.InitialiseCompleteSignal;
    import com.vango.testing.performance.viewer.init.signals.InitialiseFailedSignal;
    import com.vango.testing.performance.viewer.io.InstallIO;

    import flash.display.DisplayObjectContainer;

    import org.robotlegs.mvcs.SignalContext;

    public class ResultsViewerContext extends SignalContext
    {
        public function ResultsViewerContext(displayContext:DisplayObjectContainer)
        {
            super(displayContext, true);
        }

        override public function startup():void
        {
            // install features
            commandMap.execute(InstallIO);
            commandMap.execute(InstallData);
            commandMap.execute(InstallControls);

            // map app specific stuff
            injector.mapSingleton(InitialiseFailedSignal);
            injector.mapSingleton(InitialiseCompleteSignal);

            // initialise the application
            commandMap.execute(InitialiseApplicationCommand);

            // execute startup
            super.startup();
        }
    }
}
