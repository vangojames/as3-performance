/**
 *
 */
package com.vango.testing.performance.viewer.run.services
{
    import com.vango.testing.performance.viewer.data.vo.FileEntry;
    import com.vango.testing.performance.viewer.run.proxies.TestRunProxy;
    import com.vango.testing.performance.viewer.run.signals.TestDirectoryVerifiedSignal;
    import com.vango.testing.performance.viewer.run.vo.RunData;
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
        [Inject]
        public var testProxy:TestRunProxy;

        private var result:VerificationResult;
        private var currentDirectory:File;

        public function verifyTestDirectory(fileEntry:FileEntry):void
        {
            // stop any current processing
            if(fileRetrievalService.isProcessing)
            {
                fileRetrievalService.stopProcessing();
                trace("Stopped retrieval processing");
            }
            if(parsingService.isParsing)
            {
                parsingService.stopParsing();
                trace("Stopped file parsing");
            }

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
            var runData:RunData = new RunData();
            runData.sourceTree = structure.children;
            runData.testList = testFiles;
            runData.sourceList = sourceFiles;
            runData.externalSources = new ArrayCollection();
            runData.externalSwcs = new ArrayCollection();
            testProxy.runData = runData;
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
