/**
 *
 */
package com.vango.testing.performance.viewer.io
{
    import com.vango.testing.performance.viewer.io.commands.BrowseForDirectoryCommand;
    import com.vango.testing.performance.viewer.io.commands.BrowseForFileCommand;
    import com.vango.testing.performance.viewer.io.commands.BrowseForMultipleFilesCommand;
    import com.vango.testing.performance.viewer.io.signals.BrowseForDirectorySignal;
    import com.vango.testing.performance.viewer.io.signals.BrowseForFileSignal;
    import com.vango.testing.performance.viewer.io.signals.BrowseForMultipleFilesSignal;

    import org.robotlegs.mvcs.SignalCommand;

    public class InstallIO extends SignalCommand
    {
        override public function execute():void
        {
            // map signals to commands
            signalCommandMap.mapSignalClass(BrowseForDirectorySignal, BrowseForDirectoryCommand);
            signalCommandMap.mapSignalClass(BrowseForFileSignal, BrowseForFileCommand);
            signalCommandMap.mapSignalClass(BrowseForMultipleFilesSignal, BrowseForMultipleFilesCommand);
        }
    }
}
