/**
 *
 */
package com.vango.testing.performance.viewer.run.mediator
{
    import com.vango.testing.performance.viewer.io.signals.BrowseForDirectorySignal;
    import com.vango.testing.performance.viewer.io.signals.BrowseForFileSignal;
    import com.vango.testing.performance.viewer.io.vo.DirectoryBrowsingConfig;
    import com.vango.testing.performance.viewer.io.vo.FileBrowsingConfig;
    import com.vango.testing.performance.viewer.run.display.run.SetupView;
    import com.vango.testing.performance.viewer.run.signals.IncludeSourceSignal;
    import com.vango.testing.performance.viewer.run.signals.IncludeSwcSignal;
    import com.vango.testing.performance.viewer.run.signals.RunDataUpdatedSignal;
    import com.vango.testing.performance.viewer.run.signals.RunTestsSignal;
    import com.vango.testing.performance.viewer.run.signals.TestDirectoryVerifiedSignal;
    import com.vango.testing.performance.viewer.run.signals.VerifyTestDirectorySignal;

    import flash.filesystem.File;
    import flash.net.FileFilter;

    import org.robotlegs.mvcs.Mediator;

    public class SetupViewMediator extends Mediator
    {
        [Inject]
        public var setupView:SetupView;
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
            setupView.verifyTestSignal.add(verifyTestSignal.dispatch);
            testDirectoryVerifiedSignal.add(setupView.onTestVerified);
            runDataUpdatedSignal.add(setupView.onRunDataUpdated);
            setupView.addSourceSignal.add(browseForDirectorySignal.dispatch).params =
                    [new DirectoryBrowsingConfig(File.documentsDirectory, "Select source location", onSourceSelected)];
            setupView.addSwcSignal.add(browseForFileSignal.dispatch).params =
                    [new FileBrowsingConfig(File.documentsDirectory, "Select swc location", [new FileFilter("swc", "*.swc")], onSwcSelected)];
            setupView.runTestSignal.add(runTestsSignal.dispatch);
            super.onRegister();
        }

        override public function onRemove():void
        {
            setupView.verifyTestSignal.remove(verifyTestSignal.dispatch);
            testDirectoryVerifiedSignal.remove(setupView.onTestVerified);
            runDataUpdatedSignal.remove(setupView.onRunDataUpdated);
            setupView.addSourceSignal.remove(browseForDirectorySignal.dispatch);
            setupView.addSwcSignal.remove(browseForFileSignal.dispatch);
            setupView.runTestSignal.remove(runTestsSignal.dispatch);
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
