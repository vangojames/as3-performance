/**
 *
 */
package com.vango.testing.performance.viewer.run.display.run
{
    import com.vango.testing.performance.viewer.controls.display.FileSelector;
    import com.vango.testing.performance.viewer.controls.events.FileSelectedEvent;
    import com.vango.testing.performance.viewer.data.vo.FileEntry;
    import com.vango.testing.performance.viewer.run.display.popup.InvalidPathPopup;
    import com.vango.testing.performance.viewer.run.vo.VerificationResult;

    import flash.events.MouseEvent;

    import mx.collections.ArrayCollection;
    import mx.managers.PopUpManager;

    import org.osflash.signals.Signal;

    import spark.components.Group;

    public class RunView extends Group
    {
        [Bindable]
        public var sourceTree:ArrayCollection = null;
        [Bindable]
        public var testList:ArrayCollection = null;
        [Bindable]
        public var sourceList:ArrayCollection = null;

        public var fileSelector:FileSelector;
        public var verificationResult:VerificationResult = null;

        public const verifyTestSignal:Signal = new Signal(FileEntry);

        protected function onTestSelected(event:FileSelectedEvent):void
        {
            sourceTree = null;
            testList = null;
            sourceList = null;
            currentState = "running";
            verifyTestSignal.dispatch(event.file);
        }

        public function onTestVerified(result:VerificationResult):void
        {
            this.verificationResult = result;
            currentState = result.success ? "verified" : "unverified";

            if(!result.success)
            {
                var title:InvalidPathPopup = new InvalidPathPopup();
                title.initialise(removePath, null);
                title.width = 300;
                title.height = 200;
                PopUpManager.addPopUp(title, this, true);
                PopUpManager.centerPopUp(title);

                function removePath():void
                {
                    result.target.remove();
                    if(fileSelector.history.contains(result.target))
                    {
                        fileSelector.history.removeItemAt(fileSelector.history.getItemIndex(result.target));
                    }
                }
            }
            else
            {
                sourceTree = result.sourceTree.children;
                testList = result.testList;
                sourceList = result.sourceList;
            }
        }

        /**
         * Runs the tests
         */
        protected function runTests(event:MouseEvent):void
        {
            if(verificationResult != null && verificationResult.success)
            {
                currentState = "running"
            }
            else
            {
                throw new Error("Path not verified");
            }
        }

        /**
         * Runs the tests
         */
        protected function stopTests(event:MouseEvent):void
        {

        }
    }
}
