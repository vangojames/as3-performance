/**
 *
 */
package com.vango.testing.performance.viewer.run.mediator
{
    import com.vango.testing.performance.viewer.io.signals.BrowseForDirectorySignal;
    import com.vango.testing.performance.viewer.io.signals.BrowseForFileSignal;
    import com.vango.testing.performance.viewer.io.vo.DirectoryBrowsingConfig;
    import com.vango.testing.performance.viewer.io.vo.FileBrowsingConfig;
    import com.vango.testing.performance.viewer.run.display.run.RunView;
    import com.vango.testing.performance.viewer.run.signals.IncludeSourceSignal;
    import com.vango.testing.performance.viewer.run.signals.IncludeSwcSignal;
    import com.vango.testing.performance.viewer.run.signals.RunDataUpdatedSignal;
    import com.vango.testing.performance.viewer.run.signals.RunTestsSignal;
    import com.vango.testing.performance.viewer.run.signals.TestDirectoryVerifiedSignal;
    import com.vango.testing.performance.viewer.run.signals.VerifyTestDirectorySignal;

    import flash.filesystem.File;
    import flash.net.FileFilter;

    import org.robotlegs.mvcs.Mediator;

    public class RunViewMediator extends Mediator
    {
        [Inject]
        public var runView:RunView;
        [Inject]
        public var verifyTestSignal:VerifyTestDirectorySignal;
        [Inject]
        public var testDirectoryVerifiedSignal:TestDirectoryVerifiedSignal;
        [Inject]
        public var runDataUpdatedSignal:RunDataUpdatedSignal;
        [Inject]
        public var browseForDirectorySignal:BrowseForDirectorySignal;
        [Inject]
        public var browseForFileSignal:BrowseForFileSignal;
        [Inject]
        public var includeSourceSignal:IncludeSourceSignal;
        [Inject]
        public var includeSwcSignal:IncludeSwcSignal;
        [Inject]
        public var runTestsSignal:RunTestsSignal;

        override public function onRegister():void
        {
            runView.verifyTestSignal.add(verifyTestSignal.dispatch);
            testDirectoryVerifiedSignal.add(runView.onTestVerified);
            runDataUpdatedSignal.add(runView.onRunDataUpdated);
            runView.addSourceSignal.add(browseForDirectorySignal.dispatch).params =
                    [new DirectoryBrowsingConfig(File.documentsDirectory, "Select source location", onSourceSelected)];
            runView.addSwcSignal.add(browseForFileSignal.dispatch).params =
                    [new FileBrowsingConfig(File.documentsDirectory, "Select swc location", [new FileFilter("swc", "*.swc")], onSwcSelected)];
            runView.runTestSignal.add(runTestsSignal.dispatch);
            super.onRegister();
        }

        override public function onRemove():void
        {
            runView.verifyTestSignal.remove(verifyTestSignal.dispatch);
            testDirectoryVerifiedSignal.remove(runView.onTestVerified);
            runDataUpdatedSignal.remove(runView.onRunDataUpdated);
            runView.addSourceSignal.remove(browseForDirectorySignal.dispatch);
            runView.addSwcSignal.remove(browseForFileSignal.dispatch);
            runView.runTestSignal.remove(runTestsSignal.dispatch);
            super.onRemove();
        }

        private function onSourceSelected(source:File):void
        {
            if(source != null)
            {
                includeSourceSignal.dispatch(source);
            }
        }

        private function onSwcSelected(source:File):void
        {
            if(source != null)
            {
                includeSwcSignal.dispatch(source);
            }
        }
    }
}
