/**
 *
 */
package com.vango.testing.performance.viewer.loading
{
    import com.vango.testing.performance.viewer.controls.IControlCommand;

    import flash.filesystem.File;

    public class InitialiseTestLoadingCommand implements IControlCommand
    {
        public function execute():void
        {
            var fileLoadingService:FileLoadingService = new FileLoadingService();
            fileLoadingService.load("myKey");
            var f:File = new File();
        }
    }
}
