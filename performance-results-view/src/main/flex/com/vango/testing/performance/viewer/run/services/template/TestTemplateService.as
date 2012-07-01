/**
 *
 */
package com.vango.testing.performance.viewer.run.services.template
{
    import com.vango.testing.performance.viewer.run.vo.tree.AS3TreeTest;

    import flash.filesystem.File;
    import flash.filesystem.FileMode;
    import flash.filesystem.FileStream;
    import flash.utils.ByteArray;
    import flash.utils.Dictionary;
    import flash.utils.describeType;

    import mx.collections.ArrayCollection;

    public class TestTemplateService
    {
        [Embed(source="../../../../../../../../../resources/TestRunnerTemplate.txt", mimeType="application/octet-stream")]
        public var testRunner:Class;
        [Embed(source="../../../../../../../../../resources/TestCompilerTemplate.txt", mimeType="application/octet-stream")]
        public var testCompiler:Class;

        /**
         * Generates the test runner source based on tests that are required to run
         * @param className the name of the generated source
         * @param tests The list of tests to run
         */
        public function generateTestCompilerSource(className:String, tests:ArrayCollection):String
        {
            // generate file string
            var source:String = new testCompiler();
            // validate supported tokens
            var supportedProperties:Vector.<String> = Vector.<String>([
                TemplateProperty.CLASS_NAME,
                TemplateProperty.IMPORT_STATEMENT,
                TemplateProperty.TEST_INCLUDE,]);

            var tokenProperties:Dictionary = new Dictionary();

            for each(var property:String in supportedProperties)
            {
                var index:int = source.search(TemplateProperty.createTemplatePropertyRegEx(property, false));
                if(index == -1)
                {
                    throw new Error("Invalid template. Could not find '" + property + "' token");
                }

                var tokenWhitespace:String = getLeadingWhitespaceFromToken(source,  property);
                var tokenName:String = TemplateProperty.tokenise(property);
                var token:TokenProperty = new TokenProperty(property, tokenName, tokenWhitespace);
                tokenProperties[property] = token;
            }

            // update the class name of the template
            source = source.replace(TemplateProperty.createTemplatePropertyRegEx(TemplateProperty.CLASS_NAME, false), className);
            // now add all the tests
            for each(var test:AS3TreeTest in tests)
            {
                if(!test.isSelected) continue;
                // create the import statement with the leading import token and whitespace
                var importStatement:String = "import " + test.fullyQualifiedClassName + ";";
                source = addStatement(importStatement, source, TemplateProperty.IMPORT_STATEMENT, tokenProperties);
                // create the test include statement with the leading include token and whitespace
                var includeStatement:String = "public var " + test.fullyQualifiedClassName.replace(/\./g, "_") + ":" + test.fullyQualifiedClassName + ";";
                source = addStatement(includeStatement, source, TemplateProperty.TEST_INCLUDE, tokenProperties);
            }

            // remove template tokens
            for each(var token:TokenProperty in tokenProperties)
            {
                source = source.replace(TemplateProperty.createTemplatePropertyRegEx(token.name, true), "");
            }

            return source;
        }

        /**
         * Generates the test runner source based on tests that are required to run
         * @param className the name of the generated source
         * @param fqCompilerName The fully qualified class name of the compiler
         * @param connectionName The name of the connection to listen to
         */
        public function generateTestRunnerSource(className:String, fqComilerClassName:String, connectionName:String):String
        {
            // generate file string
            var source:String = new testRunner();
            // validate supported tokens
            var supportedProperties:Vector.<String> = Vector.<String>([
                TemplateProperty.CLASS_NAME,
                TemplateProperty.COMPILED_TESTS,
                TemplateProperty.CONNECTION_NAME,
            ]);

            var tokenProperties:Dictionary = new Dictionary();

            for each(var property:String in supportedProperties)
            {
                var index:int = source.search(TemplateProperty.createTemplatePropertyRegEx(property, false));
                if(index == -1)
                {
                    throw new Error("Invalid template. Could not find '" + property + "' token");
                }

                var tokenWhitespace:String = getLeadingWhitespaceFromToken(source,  property);
                var tokenName:String = TemplateProperty.tokenise(property);
                var token:TokenProperty = new TokenProperty(property, tokenName, tokenWhitespace);
                tokenProperties[property] = token;
            }

            // update the class name and add the comiled tests of the template
            source = source.replace(TemplateProperty.createTemplatePropertyRegEx(TemplateProperty.CLASS_NAME, false), className);
            source = source.replace(TemplateProperty.createTemplatePropertyRegEx(TemplateProperty.COMPILED_TESTS, false), fqComilerClassName);
            source = source.replace(TemplateProperty.createTemplatePropertyRegEx(TemplateProperty.CONNECTION_NAME, false), connectionName);

            // remove template tokens
            for each(var token:TokenProperty in tokenProperties)
            {
                source = source.replace(TemplateProperty.createTemplatePropertyRegEx(token.name, true), "");
            }

            return source;
        }

        /**
         * Retrieves the required test libraries
         */
        public function createRequiredSupportLibs():Vector.<File>
        {
            var supportLibs:Vector.<File> = new Vector.<File>();
            var description:XML = describeType(RequiredSwcs);
            for each(var constant:XML in description.constant)
            {
                // variable.@name + " : " + variable.@type + "\n";
                var name:String = constant.@name;
                var definition:Class = RequiredSwcs[name] as Class;
                supportLibs.push(copySupportLib(definition, name + ".swc"));
            }
            return supportLibs;
        }

        private function copySupportLib(embedded:Class, fileName:String):File
        {
            // copy the libraries to the required places
            var swc:ByteArray = new embedded();
            var swcDestination:File = File.applicationStorageDirectory.resolvePath(fileName);
            trace("Copying support lib to '" + swcDestination.nativePath + "'");
            var writer:FileStream = new FileStream();
            writer.open(swcDestination, FileMode.WRITE);
            writer.writeBytes(swc, 0, swc.length);
            writer.close();
            return swcDestination;
        }

        private function addStatement(statement:String, source:String, propertyName:String, tokenLookup:Dictionary):String
        {
            var token:TokenProperty = tokenLookup[propertyName];
            statement = token.tokenisedName + token.whitespace + statement;
            return source.replace(TemplateProperty.createTemplatePropertyRegEx(propertyName, false), statement);
        }

        private function getLeadingWhitespaceFromToken(source:String, property:String):String
        {
            var wsRegex:RegExp = TemplateProperty.createTemplatePropertyRegEx(property, true);
            var matches:Array = wsRegex.exec(source);
            if(matches == null)
            {
                return "";
            }
            return matches.whitespace;
        }
    }
}

class TokenProperty
{
    public var tokenisedName:String;
    public var whitespace:String;
    public var name:String

    public function TokenProperty(propertyName:String, tokenisedName:String, whitespace:String)
    {
        this.name = propertyName;
        this.tokenisedName = tokenisedName;
        this.whitespace = whitespace;
    }
}