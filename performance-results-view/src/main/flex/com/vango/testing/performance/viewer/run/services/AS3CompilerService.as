/**
 *
 */
package com.vango.testing.performance.viewer.run.services
{
    import com.vango.testing.performance.viewer.run.services.template.TestTemplateService;
    import com.vango.testing.performance.viewer.run.vo.RunData;
    import com.vango.testing.performance.viewer.run.vo.tree.AS3TreeLeaf;
    import com.vango.testing.performance.viewer.run.vo.tree.AS3TreeSource;
    import com.vango.testing.performance.viewer.run.vo.tree.AS3TreeTest;

    import flash.desktop.NativeProcess;
    import flash.desktop.NativeProcessStartupInfo;
    import flash.events.IOErrorEvent;
    import flash.events.NativeProcessExitEvent;
    import flash.events.ProgressEvent;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.system.Capabilities;

    import mx.collections.ArrayCollection;

    public class AS3CompilerService
    {
        [Inject]
        public var templateService:TestTemplateService;

        private var mxmlc:NativeProcess;

        private var _flexSDK:File;
        private var _mxmlc:File;
        private var _player:File;
        private var _source:File;
        private var _output:File;

        public function compile(flexSDKSource:String, playerSource:String, runData:RunData):void
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

            validateSDKAndRuntimePaths(flexSDKSource, playerSource);
            var compilerArgs:Vector.<String> = prepareCommandArgs(runData);

            var compilerOptions:NativeProcessStartupInfo = new NativeProcessStartupInfo();
            compilerOptions.executable = _mxmlc;
            compilerOptions.arguments = compilerArgs;
            mxmlc = new NativeProcess();
            mxmlc.addEventListener(ProgressEvent.STANDARD_OUTPUT_DATA, onOutputData);
            mxmlc.addEventListener(ProgressEvent.STANDARD_ERROR_DATA, onErrorData);
            mxmlc.addEventListener(NativeProcessExitEvent.EXIT, onExit);
            mxmlc.addEventListener(IOErrorEvent.STANDARD_OUTPUT_IO_ERROR, onIOError);
            mxmlc.addEventListener(IOErrorEvent.STANDARD_ERROR_IO_ERROR, onIOError);
            mxmlc.start(compilerOptions);
            trace("Launched flex compiler");
//            trace("mxmlc args : " + compilerArgs.join(" "));
//            runCommand("mxmlc", Vector.<String>(["-help"]));
//            //runCommand("mxmlc", compilerArgs);
//            runCommand("quit");
        }

        private function validateSDKAndRuntimePaths(flexSDKSource:String, playerSource:String):void
        {
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

            _mxmlc = _flexSDK.resolvePath(mxmlcFile);
            if(!_mxmlc.exists)
            {
                throw new Error("Unable to resolve path to mxmlc compiler at '" + _mxmlc.nativePath + "'");
            }

            _player = new File(playerSource);
            if(!_player.exists)
            {
                throw new Error("Unable to resolve path to player at '" + _player.nativePath + "'");
            }
        }

        /**
         * Creates and prepares any compiler commands that are required
         * @param runData
         * @return
         */
        private function prepareCommandArgs(runData:RunData):Vector.<String>
        {
            var arguments:Vector.<String> = new Vector.<String>();

            var i:int = 0;
            var count:int = runData.testList.length;
            var sourcePaths:String = "-compiler.source-path+=";
            for(i = 0; i < count; i++)
            {
                var testFile:AS3TreeTest = runData.testList.getItemAt(i) as AS3TreeTest;
                if(!testFile.isSelected) continue;
                var path:String = testFile.sourceRoot.nativePath + File.separator + ",";
                path = path.replace(/\//g, File.separator).replace(/\\/g, File.separator);
                if(sourcePaths.indexOf(path) == -1)
                {
                    sourcePaths += path;
                }
            }

            var count:int = runData.sourceList.length;
            for(i = 0; i < count; i++)
            {
                var sourceFile:AS3TreeSource = runData.sourceList.getItemAt(i) as AS3TreeSource;
                if(!sourceFile.isSelected) continue;
                var path:String = sourceFile.sourceRoot.nativePath + File.separator + ",";
                path = path.replace(/\//g, File.separator).replace(/\\/g, File.separator);
                if(sourcePaths.indexOf(path) == -1)
                {
                    sourcePaths += path;
                }
            }

            // now run the commands
            count = runData.externalSources.length;
            for(i = 0; i < count; i++)
            {
                sourcePaths += runData.externalSources.getItemAt(i);
                if(i < (count - 1))
                {
                    sourcePaths += ",";
                }
            }

            var externalLibraryPath:String = "-compiler.library-path+=";
            count = runData.externalSwcs.length;
            for(i = 0; i < count; i++)
            {
                externalLibraryPath += runData.externalSwcs.getItemAt(i);
                if(i < (count - 1))
                {
                    externalLibraryPath += ",";
                }
            }

            var className:String = "TestRunner";

            _source = createSource(className, runData.testList);
            _output = File.applicationStorageDirectory.resolvePath("compiledTests/" + className + ".swf");
            if(!_output.parent.exists)
            {
                _output.parent.createDirectory();
            }

            // execute the compiler command and then quit
            const QUOTE:String = "";
            var parsedSourcePath:String = QUOTE + _source.nativePath + QUOTE;
            var parsedOutputPath:String = QUOTE + _output.nativePath + QUOTE;

            arguments.push("-static-link-runtime-shared-libraries=true");
            arguments.push(parsedSourcePath);
            arguments.push(sourcePaths);
            arguments.push(externalLibraryPath);

            return arguments;
        }

        private function createSource(className:String, tests:ArrayCollection):File
        {
            // generate file string
            var fileString:String = templateService.generateTestRunnerSource(className, tests);
            // now write and return the file
            var sourceFile:File = File.applicationStorageDirectory.resolvePath("compiledTests/" + className + ".as");
            if(!sourceFile.parent.exists)
            {
                sourceFile.parent.createDirectory();
            }
            var fileWriter:FileStream = new FileStream();
            fileWriter.open(sourceFile, FileMode.WRITE);
            fileWriter.writeUTFBytes(fileString);
            return sourceFile;
        }

        /**
         * Runs a command on the fcsh console
         * @param command The command to run
         * @param args The arguments to pass to the command
         */
        private function runCommand(command:String, args:Vector.<String> = null):void
        {
            if(args && args.length)
            {
                command += args.join(" ");
            }
            command += File.lineEnding;
            mxmlc.standardInput.writeUTFBytes(command);
        }

        public function onOutputData(event:ProgressEvent):void
        {
            trace(mxmlc.standardOutput.readUTFBytes(mxmlc.standardOutput.bytesAvailable));
        }

        public function onErrorData(event:ProgressEvent):void
        {
            trace("ERROR -", mxmlc.standardError.readUTFBytes(mxmlc.standardError.bytesAvailable));
        }

        public function onExit(event:NativeProcessExitEvent):void
        {
            if(event.exitCode == 0)
            {
                trace("mxmlc exited with ", event.exitCode);
                // now launch the compiled swf
                var playerOptions:NativeProcessStartupInfo = new NativeProcessStartupInfo();
                playerOptions.executable = _player;
                playerOptions.arguments = Vector.<String>([_output.nativePath]);
                var player:NativeProcess = new NativeProcess();
                player.start(playerOptions);
            }
            else
            {
                trace("mxmlc exited with failure ", event.exitCode);
            }
        }

        public function onIOError(event:IOErrorEvent):void
        {
            trace(event.toString());
        }

        public function unwatch(prop:String):void
        {
            super.unwatch(prop);
        }
    }
}
