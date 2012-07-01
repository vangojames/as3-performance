/**
 *
 */
package com.vango.testing.performance.viewer.run.services.compilation
{
    import avmplus.getQualifiedClassName;

    import com.vango.testing.performance.viewer.run.services.running.AS3RunningService;
    import com.vango.testing.performance.viewer.run.services.template.TestTemplateService;
    import com.vango.testing.performance.viewer.run.vo.RunData;
    import com.vango.testing.performance.viewer.run.vo.tree.AS3TreeLeaf;

    import flash.desktop.NativeProcess;
    import flash.desktop.NativeProcessStartupInfo;
    import flash.events.IOErrorEvent;
    import flash.events.NativeProcessExitEvent;
    import flash.events.ProgressEvent;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.system.Capabilities;
    import flash.utils.Dictionary;

    import mx.collections.ArrayCollection;

    public class AS3CompilerService
    {
        [Inject]
        public var templateService:TestTemplateService;
        [Inject]
        public var runningService:AS3RunningService;

        private var mxmlc:NativeProcess;

        private var _flexSDK:File;
        private var _mxmlcPath:File;
        private var _playerPath:File;
        private var _compiledSWFPath:File;

        private const COMPILER_CLASS_NAME:String = "TestCompiler";
        private const RUNNER_CLASS_NAME:String = "TestRunner";
        private const LOCAL_CONNECTION_NAME:String = "_performanceTestRunner";

        /**
         * Compiles the tests and sources into a swf
         * @param flexSDKSource The path to the flex sdk
         * @param playerSource The path to the player
         * @param runData The run data required
         */
        public function compileTestSWF(flexSDKSource:String, playerSource:String, runData:RunData):void
        {
            // validate the runtime paths
            validateSDKAndRuntimePaths(flexSDKSource, playerSource);
            // generate required sources and libraries
            var compiler:File = createCompilerSource(COMPILER_CLASS_NAME, runData.testList);
            var testRunner:File = createTestRunnerSource(RUNNER_CLASS_NAME, COMPILER_CLASS_NAME);
            _compiledSWFPath = testRunner.parent.resolvePath(RUNNER_CLASS_NAME + ".swf");
            var externalLibPaths:Vector.<File> = getUniqueLibraryPaths(runData.externalSwcs);
            var sourceRoots:Vector.<File> = getUniqueSourceRoots(compiler, runData.externalSources, runData.sourceList, runData.testList);
            var compilerOptions:NativeProcessStartupInfo = new NativeProcessStartupInfo();
            compilerOptions.executable = _mxmlcPath;
            compilerOptions.arguments = prepareCompilerArgs(testRunner, sourceRoots, externalLibPaths);
            mxmlc = new NativeProcess();
            mxmlc.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData);
            mxmlc.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, onErrorData);
            mxmlc.addEventListener(NativeProcessExitEvent.EXIT, onExit);
            mxmlc.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onIOError);
            mxmlc.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, onIOError);
            mxmlc.start(compilerOptions);
        }

        /**
         * Validates the paths to the SDK and player runtime
         * @param flexSDKSource The path to the sdk
         * @param playerSource The player path
         */
        private function validateSDKAndRuntimePaths(flexSDKSource:String, playerSource:String):void
        {
            // first validate the flex sdk
            if(flexSDKSource == null)
            {
                throw new Error("You must pass a valid flex sdk");
            }
            if(playerSource == null)
            {
                throw new Error("You must pass a valid player source");
            }

            _flexSDK = new File(flexSDKSource);
            if(!_flexSDK.exists)
            {
                throw new Error("Flex SDK could not be found at '" + flexSDKSource + "'");
            }

            var mxmlcFile:String;
            var os:String = Capabilities.os;
            if(Capabilities.os.indexOf('mac') >= 0)
            {
                mxmlcFile = "bin/mxmlc";
            }
            else
            {
                mxmlcFile = "bin/mxmlc.exe";
            }

            _mxmlcPath = _flexSDK.resolvePath(mxmlcFile);
            if(!_mxmlcPath.exists)
            {
                throw new Error("Unable to resolve path to mxmlc compiler at '" + _mxmlcPath.nativePath + "'");
            }

            _playerPath = new File(playerSource);
            if(!_playerPath.exists)
            {
                throw new Error("Unable to resolve path to player at '" + _playerPath.nativePath + "'");
            }
        }

        /**
         * Creates the source file containing references to the tests that need to be compiled into the runner
         * @param className The class name of the compiler file
         * @param tests The list of tests to compile in
         * @return The path to the compiler source
         */
        private function createCompilerSource(className:String, tests:ArrayCollection):File
        {
            // generate file string
            var fileString:String = templateService.generateTestCompilerSource(className, tests);
            // now write and return the file
            var sourceFile:File = File.applicationStorageDirectory.resolvePath("compiledTests/" + className + ".as");
            if(!sourceFile.parent.exists)
            {
                sourceFile.parent.createDirectory();
            }
            var fileWriter:FileStream = new FileStream();
            fileWriter.open(sourceFile, FileMode.WRITE);
            fileWriter.writeUTFBytes(fileString);
            fileWriter.close();
            return sourceFile;
        }

        /**
         * Creates the source file for the test runner and returns the file
         * @param className The class name of the test file
         * @param compilerName The name of the compiler class to use
         * @return The path to the source file
         */
        private function createTestRunnerSource(className:String, compilerName:String):File
        {
            // generate file string
            var fileString:String = templateService.generateTestRunnerSource(className, compilerName, LOCAL_CONNECTION_NAME);
            // now write and return the file
            var sourceFile:File = File.applicationStorageDirectory.resolvePath("compiledTests/" + className + ".as");
            if(!sourceFile.parent.exists)
            {
                sourceFile.parent.createDirectory();
            }
            var fileWriter:FileStream = new FileStream();
            fileWriter.open(sourceFile, FileMode.WRITE);
            fileWriter.writeUTFBytes(fileString);
            fileWriter.close();
            return sourceFile;
        }

        /**
         * Retrieves the base path for all required support libraries
         */
        private function getUniqueLibraryPaths(externalSwcs:ArrayCollection):Vector.<File>
        {
            var includedPaths:Dictionary = new Dictionary();
            var uniquePaths:Vector.<File> = new Vector.<File>();
            // add all the unique paths from the external swcs
            addUniquePaths(externalSwcs, uniquePaths, includedPaths);
            var supportLibraries:Vector.<File> = templateService.createRequiredSupportLibs();
            // include the support libraries
            for each(var lib:File in supportLibraries)
            {
                if(!includedPaths.hasOwnProperty(lib.nativePath))
                {
                    uniquePaths.push(lib);
                    includedPaths[lib.nativePath] = true;
                }
            }
            return uniquePaths;
        }

        /**
         * Retrieves all unique roots to include in the compilation arguments
         * @param sources The list of source paths to include
         * @param tests The list of test files to include
         * @return The list of unique roots
         */
        private function getUniqueSourceRoots(compiler:File, externalSources:ArrayCollection, sources:ArrayCollection, tests:ArrayCollection):Vector.<File>
        {
            var includedRoots:Dictionary = new Dictionary();
            var roots:Vector.<File> = new Vector.<File>();
            includedRoots[compiler.nativePath] = true;
            roots.push(compiler.parent);
            // add all the unique paths
            addUniquePaths(externalSources, roots, includedRoots);
            addUniquePaths(sources, roots, includedRoots);
            addUniquePaths(tests, roots, includedRoots);

            return roots;
        }

        /**
         * Adds all paths not currently in the list to the output and includes in the included paths for fast indexing
         * @param list The list to include
         * @param output The place to push to
         * @param includedPaths The hash to push included paths to for quick lookup
         */
        private function addUniquePaths(list:ArrayCollection, output:Vector.<File>, includedPaths:Dictionary):void
        {
            var rootPath:File;
            var l:int = list.length;
            for(var i:int = 0; i < l; i++)
            {
                var entry:* = list.getItemAt(i);
                if(entry is AS3TreeLeaf)
                {
                    if(!AS3TreeLeaf(entry).isSelected) continue;
                    rootPath = AS3TreeLeaf(entry).sourceRoot;
                }
                else if(entry is String)
                {
                    rootPath = new File(String(entry));
                }
                else
                {
                    throw new Error("Entry type '" + getQualifiedClassName(entry) + "' is not supported");
                }
                if(!includedPaths.hasOwnProperty(rootPath.nativePath))
                {
                    output.push(rootPath);
                    includedPaths[rootPath.nativePath] = true;
                }
            }
        }

        /**
         * Creates and prepares any compiler commands that are required
         * @param runData The configuration data to run
         * @return The list of arguments to pass to the compiler
         */
        private function prepareCompilerArgs(testRunner:File, sources:Vector.<File>, libraries:Vector.<File>):Vector.<String>
        {
            var arguments:Vector.<String> = new Vector.<String>();

            var sourcePaths:String = "-compiler.source-path+=";
            var i:int = 0, count:int = sources.length;
            for each(var source:File in sources)
            {
                // parse the path
                sourcePaths += getPath(source);
                if(i < (count - 1))
                {
                    sourcePaths += ",";
                }
                ++i;
            }

            var libraryPaths:String = "-compiler.library-path+=";
            i = 0; count = libraries.length;
            for each(var lib:File in libraries)
            {
                libraryPaths += getPath(lib);
                if(i < (count - 1))
                {
                    libraryPaths += ",";
                }
                ++i;
            }

            // add all the args and return
            arguments.push("-static-link-runtime-shared-libraries=true");
            arguments.push(getPath(testRunner));
            arguments.push(sourcePaths);
            arguments.push(libraryPaths);
            arguments.push("-keep-as3-metadata+=Before,After,Test");

            return arguments;
        }

        /**
         * support function for cleaning up the path for the compiler
         */
        private function getPath(f:File):String
        {
            return (f.nativePath + File.separator).replace(/[\/+]|[\\+]/g, File.separator);
        }

        private function onOutputData(event:ProgressEvent):void
        {
            trace(mxmlc.standardOutput.readUTFBytes(mxmlc.standardOutput.bytesAvailable));
        }

        private function onErrorData(event:ProgressEvent):void
        {
            trace("ERROR -", mxmlc.standardError.readUTFBytes(mxmlc.standardError.bytesAvailable));
        }

        private function onExit(event:NativeProcessExitEvent):void
        {
            if(event.exitCode == 0)
            {
                trace("mxmlc exited with ", event.exitCode);
                runningService.run(_playerPath, _compiledSWFPath, LOCAL_CONNECTION_NAME);
            }
            else
            {
                trace("mxmlc exited with failure ", event.exitCode);
            }
        }

        private function onIOError(event:IOErrorEvent):void
        {
            trace(event.toString());
        }
    }
}
