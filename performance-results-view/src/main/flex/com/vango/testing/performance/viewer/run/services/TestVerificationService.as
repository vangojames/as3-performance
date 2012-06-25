/**
 *
 */
package com.vango.testing.performance.viewer.run.services
{
    import com.vango.testing.performance.viewer.data.vo.FileEntry;
    import com.vango.testing.performance.viewer.run.vo.AS3TreeNode;
    import com.vango.testing.performance.viewer.run.vo.VerificationResult;

    import flash.filesystem.File;

    import mx.collections.ArrayCollection;

    public class TestVerificationService
    {
        [Inject]
        public var fileRetrievalService:FileRetrievalService;
        [Inject]
        public var parsingService:AS3ParsingService;

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
                fileRetrievalService.retrieveAllFiles(dir, onFilesRetrieved, asFileFilter);
            }

            function onFilesRetrieved(files:Vector.<File>):void
            {
                result.success = files.length > 0;
                parsingService.parseFiles(dir, files, onFilesParsed);
            }

            function onFilesParsed(structure:AS3TreeNode, testFiles:ArrayCollection):void
            {
                result.sourceTree = structure;
                result.testList = testFiles;
                callback(result);
            }
        }

        private function asFileFilter(file:File):Boolean
        {
            const AS_EXT:String = "as";
            if(file.extension != AS_EXT)
            {
                return false;
            }
            else
            {
                return true;
            }
        }
    }
}
