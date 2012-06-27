/**
 *
 */
package com.vango.testing.performance.viewer.run.services
{
    import com.vango.testing.performance.viewer.controls.signals.UpdateStatusSignal;
    import com.vango.testing.performance.viewer.run.vo.tree.AS3TreeFolder;
    import com.vango.testing.performance.viewer.run.vo.tree.AS3TreeLeaf;
    import com.vango.testing.performance.viewer.run.vo.tree.AS3TreeSource;
    import com.vango.testing.performance.viewer.run.vo.tree.AS3TreeTest;

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
        private var _sourceRoots:AS3TreeFolder;
        private var _testFiles:ArrayCollection;
        private var _sourceFiles:ArrayCollection;
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
            _sourceRoots = new AS3TreeFolder("", searchRoot, new ArrayCollection());
            _testFiles = new ArrayCollection();
            _sourceFiles = new ArrayCollection();
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
            _isParsing = false;
            _testFiles = null;
            _sourceFiles = null;
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
                var parseCount:int = _testFiles.length + _sourceFiles.length
                trace("Parsed " + parseCount + " files in " + dt + "ms and found " + _testFiles.length + " test files");
                _onComplete(_sourceRoots, _testFiles, _sourceFiles);
            }
        }

        /**
         * Parses the contents of an as3 file
         */
        private function parseFile(location:File, fileContents:String):void
        {
            // configure a leaf node for the file
            var leafNode:AS3TreeLeaf;
            leafNode = fileIsTestFile(location) ? new AS3TreeTest() : new AS3TreeSource() ;
            leafNode.nativeLocation = location;
            leafNode.name = location.name;
            leafNode.packageName = getFilePackage(fileContents);
            // now extract the package directory and calculate the root for the file
            var packageDirectory:String = getPackageDirectory(leafNode.packageName);
            var sourceRoot:File = getSourceRoot(location, packageDirectory);
            // if the file exists then continue parsing and add
            if(sourceRoot.exists)
            {
                // set the source root on the leaf node
                leafNode.sourceRoot = sourceRoot;
                // now get the root folder node for the leaf and add to it
                var rootFolderNode:AS3TreeFolder;
                var relativeRootPath:String = _searchRoot.getRelativePath(leafNode.sourceRoot);
                if(relativeRootPath == null)
                {
                    relativeRootPath = leafNode.sourceRoot.name;
                }
                // if no node exists then create a new one and add it to the source root
                if(!_sourceRoots.contains(relativeRootPath))
                {
                    rootFolderNode = new AS3TreeFolder(relativeRootPath, leafNode.sourceRoot, new ArrayCollection());
                    _sourceRoots.addNode(rootFolderNode);
                }
                // otherwise get the existing one
                else
                {
                    rootFolderNode = AS3TreeFolder(_sourceRoots.getNode(relativeRootPath));
                }
                includePathInSourceRoot(rootFolderNode, packageDirectory, leafNode);
            }
            // otherwise do not add as it cannot be resolved for compilation
            else
            {
                trace("WARNING : Package could not be resolved so it will be ignored @ '" + location.nativePath + "'");
            }
        }

        /**
         * Runs through and includes the as3 tree leaf root path in the as3 tree folder
         * @param folderNode The folder to add to
         * @param packageDirectory The package directory to add
         * @param leafNode The file to add
         */
        private function includePathInSourceRoot(folderNode:AS3TreeFolder, packageDirectory:String, leafNode:AS3TreeLeaf):void
        {
            var nodeIsTest:Boolean = leafNode is AS3TreeTest;
            // set the flag on the folder node
            if(nodeIsTest)
            {
                folderNode.containsTest = true;
            }
            else
            {
                folderNode.containsSource = true;
            }
            var packageFolders:Array = packageDirectory.split("\\");
            var l:int = packageFolders.length;
            var currentNode:AS3TreeFolder = folderNode;
            for(var i:int = 0; i < l; i++)
            {
                var src:String = packageFolders[i];
                var srcNode:AS3TreeFolder;
                if(src != "")
                {
                    if(!currentNode.contains(src))
                    {
                        srcNode = new AS3TreeFolder(src, new File(currentNode.nativePath + "\\" + src), new ArrayCollection());
                        currentNode.addNode(srcNode);
                    }
                    currentNode = AS3TreeFolder(currentNode.getNode(src));
                    if(nodeIsTest)
                    {
                        currentNode.containsTest = true;
                    }
                    else
                    {
                        currentNode.containsSource = true;
                    }
                }
            }

            //currentNode.nativePath + "\\" + leafNode.name
            leafNode.relativeName = packageDirectory + "\\" + leafNode.name;
            if(nodeIsTest)
            {
                _testFiles.addItem(leafNode);
            }
            else
            {
                _sourceFiles.addItem(leafNode);
            }
            currentNode.addNode(leafNode);
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
