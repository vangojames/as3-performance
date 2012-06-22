/**
 *
 */
package com.vango.testing.performance.viewer.run.services
{
    import com.vango.testing.performance.viewer.data.vo.FileEntry;
    import com.vango.testing.performance.viewer.run.vo.FilteredTestFile;
    import com.vango.testing.performance.viewer.run.vo.IFilteredFile;
    import com.vango.testing.performance.viewer.run.vo.VerificationResult;

    import flash.filesystem.File;

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

            function onListingRetrieved(listing:XML):void
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

        private function performanceTestFilter(file:File):IFilteredFile
        {
            var result:FilteredTestFile = new FilteredTestFile();
            const AS_EXT:String = "as";
            if(file.extension != AS_EXT)
            {
                result.isValid = false;
                return result;
            }
            result.isValid = true;
            const AS_TEST_ID:String = "Test";
            var name:String = file.name.split(".")[0];
            var start:String = name.substr(0, AS_TEST_ID.length);
            var end:String = name.substr(name.length - AS_TEST_ID.length);
            var attributes:Object = {isTest:true};
            result.attributes = attributes;
            if(start != "Test" && end != "Test")
            {
                attributes.isTest = false;
            }
            return result;
        }
    }
}
