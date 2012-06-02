/**
 *
 */
package
{
    import flash.display.StageAlign;
    import flash.display.StageScaleMode;
    import flash.events.Event;
    import flash.events.MouseEvent;

    import mx.collections.ArrayList;

    import org.robotlegs.core.IContext;

    import spark.components.Button;
    import spark.components.WindowedApplication;

    public class ResultsViewer extends WindowedApplication
    {
        private var _context:IContext;

        public function onAddedToStage(event:Event):void
        {
            // setup stage
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;

            // create context
            _context = new ResultsViewerContext(this);
        }
    }
}
