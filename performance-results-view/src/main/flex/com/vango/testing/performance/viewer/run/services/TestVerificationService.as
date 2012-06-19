/**
 *
 */
package com.vango.testing.performance.viewer.run.services
{
    import com.vango.testing.performance.viewer.data.vo.FileEntry;
    import com.vango.testing.performance.viewer.run.vo.VerificationResult;

    import flash.filesystem.File;

    import mx.collections.ArrayCollection;

    public class TestVerificationService
    {
        [Inject]
        public var fileRetrievalService:FileRetrievalService

        public function verifyTestDirectory(fileEntry:FileEntry, callback:Function):void
        {
            var result:VerificationResult = new VerificationResult();
            result.target = fileEntry;
            var dir:File = new File(fileEntry.path);
            if(!dir.exists)
            {
                result.success = false;
                result.msg = "The path '" + fileEntry.path + "' could not be resolved";
            }
            else if(!dir.isDirectory)
            {
                result.success = false;
                result.msg = "The path '" + fileEntry.path + "' is not a directory";
            }
            else
            {
                if(fileRetrievalService.isProcessing)
                {
                    fileRetrievalService.stopProcessing();
                    trace("Stopped retrieval processing");
                }
                fileRetrievalService.retrieveAllFiles(dir, onListingRetrieved, performanceTestFilter);
            }

            function onListingRetrieved(listing:ArrayCollection):void
            {
                if(listing.length == 0)
                {
                    result.fileList = null;
                    result.success = false;
                    result.msg = "The path '" + fileEntry.path + "' does not contain any tests";
                }
                else
                {
                    result.fileList = listing;
                    result.success = true;
                    result.msg = "The path '" + fileEntry.path + "' contains " + listing.length + " files";
                }

                callback(result);
            }
        }

        private function performanceTestFilter(file:File):Boolean
        {
            if( file.extension != "as") return false;
            if( file.name.substring(0, "Test".length) != "Test" &&
                file.name.substring(file.name.length - "Test".length, file.name.length) != "Test") return false;
            return true;
        }
    }
}
