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

    import spark.components.Button;
    import spark.components.WindowedApplication;

    public class ResultsMain extends WindowedApplication
    {
        public function onAddedToStage(event:Event):void
        {
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.align = StageAlign.TOP_LEFT;
        }
    }
}
