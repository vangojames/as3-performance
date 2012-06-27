/**
 *
 */
package com.vango.testing.performance.viewer.run.services
{
    import com.vango.testing.performance.viewer.data.vo.FileEntry;
    import com.vango.testing.performance.viewer.run.signals.TestDirectoryVerifiedSignal;
    import com.vango.testing.performance.viewer.run.vo.VerificationResult;
    import com.vango.testing.performance.viewer.run.vo.tree.AS3TreeFolder;

    import flash.filesystem.File;

    import mx.collections.ArrayCollection;

    public class TestVerificationService
    {
        [Inject]
        public var testDirectoryVerifiedSignal:TestDirectoryVerifiedSignal;
        [Inject]
        public var fileRetrievalService:FileRetrievalService;
        [Inject]
        public var parsingService:AS3ParsingService;

        private var result:VerificationResult;
        private var currentDirectory:File;

        public function verifyTestDirectory(fileEntry:FileEntry):void
        {
            result = new VerificationResult();
            result.target = fileEntry;
            currentDirectory = new File(fileEntry.path);
            if(!currentDirectory.exists)
            {
                result.success = false;
                result.msg = "The path '" + fileEntry.path + "' could not be resolved";
            }
            else if(!currentDirectory.isDirectory)
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
                fileRetrievalService.retrieveAllFiles(currentDirectory, onFilesRetrieved, asFileFilter);
            }
        }

        private function onFilesRetrieved(files:Vector.<File>):void
        {
            result.success = files.length > 0;
            parsingService.parseFiles(currentDirectory, files, onFilesParsed);
        }

        private function onFilesParsed(structure:AS3TreeFolder, testFiles:ArrayCollection, sourceFiles:ArrayCollection):void
        {
            result.sourceTree = structure;
            result.testList = testFiles;
            result.sourceList = sourceFiles;
            testDirectoryVerifiedSignal.dispatch(result);
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
