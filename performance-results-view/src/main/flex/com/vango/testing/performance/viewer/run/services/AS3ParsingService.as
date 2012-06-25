/**
 *
 */
package com.vango.testing.performance.viewer.run.services
{
    import com.vango.testing.performance.viewer.controls.signals.UpdateStatusSignal;
    import com.vango.testing.performance.viewer.run.vo.AS3File;
    import com.vango.testing.performance.viewer.run.vo.AS3TreeNode;

    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.utils.getTimer;

    import mx.collections.ArrayCollection;

    public class AS3ParsingService
    {
        [Inject]
        public var updateStatusSignal:UpdateStatusSignal;

        public function get isParsing():Boolean
        {
            return _isParsing;
        }
        private var _isParsing:Boolean;

        private var _fileStream:FileStream = new FileStream();
        private var _searchRoot:File;
        private var _processingQueue:Vector.<File>;
        private var _sourceRoots:AS3TreeNode;
        private var _testFiles:ArrayCollection;
        private var _parsedFiles:Vector.<AS3File>;
        private var _currentFile:File;
        private var _onComplete:Function;
        private var _parsingStartTime:int;
        private var _targetFrameRate:int = 24;
        private var _threshold:int = 1000 / _targetFrameRate;

        public function AS3ParsingService()
        {
            _fileStream.addEventListener(Event.COMPLETE, onFileOpened);
            _fileStream.addEventListener(IOErrorEvent.IO_ERROR, onFileFailed);
        }

        /**
         * Parses the list of files into AS3File objects
         * @param files The files to parse
         */
        public function parseFiles(searchRoot:File, files:Vector.<File>, callback:Function):void
        {
            if(isParsing)
            {
                throw new Error("Already parsing, call stopParsing before retrieving files");
            }
            _isParsing = true;

            _parsingStartTime = getTimer();
            trace("Parsing '" + files.length + " files");
            // add all valid files to the list
            this._searchRoot = searchRoot;
            _processingQueue = new Vector.<File>();
            _onComplete = callback;
            for each(var file:File in files)
            {
                assertIsFile(file);
                _processingQueue.push(file);
            }
            _sourceRoots = new AS3TreeNode("", "", new ArrayCollection(), null);
            _parsedFiles = new Vector.<AS3File>();
            _testFiles = new ArrayCollection();
            // begin parsing
            parseNext();
        }

        /**
         * Stops parsing any files that are currently being parsed
         */
        public function stopParsing():void
        {
            if(!isParsing)
            {
                throw new Error("Files are not being parsed");
            }
            var dt:int = getTimer() - _parsingStartTime;
            trace("Stopped parsing files after " + dt + "ms");
            _fileStream.close();
            _searchRoot = null;
            _sourceRoots = null;
            _currentFile = null;
            _processingQueue = null;
            _onComplete = null;
            _parsedFiles = null;
            _isParsing = false;
            _testFiles = null;
        }

        /**
         * Asserts whether or not the file is a file and exists
         * @param file
         */
        private function assertIsFile(file:File):void
        {
            if(!file.exists)
            {
                throw new Error("File '" + file.nativePath + "' does not exist");
            }
            if(file.isDirectory)
            {
                throw new Error("File '" + file.nativePath + "' is a directory not an actionscript file");
            }
        }

        /**
         * Parses the next file in the list
         */
        private function parseNext():void
        {
            var isComplete:Boolean = _processingQueue.length == 0;
            if(!isComplete)
            {
                var startTime:int = getTimer();
                while(getTimer() - startTime < _threshold && _processingQueue.length > 0)
                {
                    _currentFile = _processingQueue.pop();
                    updateStatusSignal.dispatch("Parsing '" + _currentFile.nativePath + "'");
                    _fileStream.open(_currentFile, FileMode.READ);
                    parseCurrentFile();
                }

                isComplete = _processingQueue.length == 0;
                if(!isComplete)
                {
                    _currentFile = _processingQueue.pop();
                    updateStatusSignal.dispatch("Parsing '" + _currentFile.nativePath + "'");
                    _fileStream.openAsync(_currentFile, FileMode.READ);
                }
            }

            if(isComplete)
            {
                _isParsing = false;
                updateStatusSignal.dispatch("");
                var dt:int = getTimer() - _parsingStartTime;
                trace("Parsed " + _parsedFiles.length + " files in " + dt + "ms and found " + _testFiles.length + " test files");
                _onComplete(_sourceRoots, _testFiles);
            }
        }

        /**
         * Parses the contents of an as3 file
         */
        private function parseFile(location:File, fileContents:String):void
        {
            var file:AS3File = new AS3File();
            file.location = location;
            file.name = location.name;
            file.isTest = fileIsTestFile(location);
            file.packageName = getFilePackage(fileContents);
            var packageDirectory:String = getPackageDirectory(file.packageName);
            var sourceRoot:File = getSourceRoot(location, packageDirectory);
            if(sourceRoot.exists)
            {
                file.sourceRoot = sourceRoot;

                var rootStructure:AS3TreeNode;
                var relativeRootPath:String = _searchRoot.getRelativePath(file.sourceRoot);
                if(relativeRootPath == null)
                {
                    relativeRootPath = file.sourceRoot.name;
                }

                if(!_sourceRoots.contains(relativeRootPath))
                {
                    rootStructure = new AS3TreeNode(relativeRootPath, file.sourceRoot.nativePath, new ArrayCollection(), file);
                    _sourceRoots.addNode(rootStructure);
                }
                else
                {
                    rootStructure = _sourceRoots.getNode(relativeRootPath);
                }
                includePathInSourceRoot(rootStructure, packageDirectory, file);
                // add to the parsed files list
                _parsedFiles.push(file);
            }
            else
            {
                trace("WARNING : Package could not be resolved so it will be ignored @ '" + location.nativePath + "'");
            }
        }

        private function includePathInSourceRoot(root:AS3TreeNode, packageDirectory:String, file:AS3File):void
        {
            if(file.isTest)
            {
                root.containsTest = true;
            }

            var packageFolders:Array = packageDirectory.split("\\");
            var l:int = packageFolders.length;
            var currentNode:AS3TreeNode = root;
            for(var i:int = 0; i < l; i++)
            {
                var src:String = packageFolders[i];
                var srcNode:AS3TreeNode;
                if(src != "")
                {
                    if(!currentNode.contains(src))
                    {
                        srcNode = new AS3TreeNode(src, currentNode.nativePath + "\\" + src, new ArrayCollection(), file);
                        currentNode.addNode(srcNode);
                    }
                    currentNode = currentNode.getNode(src);
                    if(file.isTest)
                    {
                        currentNode.containsTest = true;
                    }
                }
            }
            var fileNode:AS3TreeNode = new AS3TreeNode(file.name, currentNode.nativePath + "\\" + file.name, null, file);
            fileNode.isTest = file.isTest;
            if(file.isTest)
            {
                fileNode.relativeName = packageDirectory + "\\" + file.name;
                _testFiles.addItem(fileNode);
            }
            currentNode.addNode(fileNode);
        }

        /**
         * Determines whether the file is a test or not
         * @param file The file to check
         * @return True if it is a test
         */
        private function fileIsTestFile(file:File):Boolean
        {
            const AS_TEST_ID:String = "Test";
            var name:String = file.name.split(".")[0];
            var start:String = name.substr(0, AS_TEST_ID.length);
            var end:String = name.substr(name.length - AS_TEST_ID.length);
            if(start != "Test" && end != "Test")
            {
                return false;
            }
            else
            {
                return true;
            }
        }

        /**
         * Gets the as3 package name from the file
         * @param fileContents The contents of the file
         * @return The file
         */
        private function getFilePackage(fileContents:String):String
        {
            var packageExp:RegExp = /(?:[\*\/\s]*)package\s(?P<packageName>\S+)\s+?\{/gs;
            var packages:Array = packageExp.exec(fileContents);
            if(packages == null || packages.length == 0)
            {
                return "";
            }
            else
            {
                return packages.packageName;
            }
        }

        /**
         * Retrieves the directory of the package relative to its source root
         * @param packageName
         * @return
         */
        private function getPackageDirectory(packageName:String):String
        {
            return packageName.replace(/\./g, "\\");
        }

        /**
         * Retrieves the directory of the source root for the file based on the current location and the package name
         * @return
         */
        private function getSourceRoot(location:File, packageDirectory:String):File
        {
            if(packageDirectory == "")
            {
                if(location.isDirectory)
                {
                    return new File(location.nativePath);
                }
                else
                {
                    return location.parent;
                }
            }
            else
            {
                var packagePath:String = packageDirectory.replace(/\./g, "\\");
                var start:int = location.nativePath.indexOf(packagePath);
                return new File(location.nativePath.substr(0, start));
            }
        }

        /**
         * Handles file open complete
         */
        private function onFileOpened(event:Event):void
        {
            // now parse the current file in the stream
            parseCurrentFile();
            // now parse the next file in the list
            parseNext();
        }

        private function parseCurrentFile():void
        {
            // read the file
            var fileContents:String = _fileStream.readUTFBytes(_fileStream.bytesAvailable);
            // close the file stream
            _fileStream.close();

            // now parse the file
            parseFile(_currentFile, fileContents);
        }

        /**
         * Handles file open failing
         */
        private function onFileFailed(event:IOErrorEvent):void
        {
            trace("Failed to parse file '" + event + "'");
            // make sure the stream is closed
            _fileStream.close();
            parseNext();
        }
    }
}
