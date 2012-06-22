/**
 *
 */
package com.vango.testing.performance.viewer.run.display
{
    import com.vango.testing.performance.viewer.controls.display.FileSelector;
    import com.vango.testing.performance.viewer.controls.events.FileSelectedEvent;
    import com.vango.testing.performance.viewer.data.vo.FileEntry;
    import com.vango.testing.performance.viewer.run.vo.VerificationResult;

    import flash.events.MouseEvent;

    import mx.collections.XMLListCollection;
    import mx.controls.Tree;
    import mx.managers.PopUpManager;

    import org.osflash.signals.Signal;

    import spark.components.Group;

    public class RunView extends Group
    {
        [Bindable]
        public var testList:XMLListCollection = new XMLListCollection(null);

        public var fileSelector:FileSelector;
        public var fileTree:Tree;
        public var verificationResult:VerificationResult = null;

        public const verifyTestSignal:Signal = new Signal(FileEntry, Function);

        protected function onTestSelected(event:FileSelectedEvent):void
        {
            fileTree.dataProvider = null;
            verifyTestSignal.dispatch(event.file, onTestVerified);
        }

        private function onTestVerified(result:VerificationResult):void
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
                var f:XMLListCollection = new XMLListCollection(result.fileList.file);
                fileTree.dataProvider = f;
                fileTree.expandChildrenOf(f, true);
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
