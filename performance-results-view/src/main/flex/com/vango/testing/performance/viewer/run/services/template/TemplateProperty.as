/**
 *
 */
package com.vango.testing.performance.viewer.run.services.template
{
    public class TemplateProperty
    {
        public static const CLASS_NAME:String = "template.className";
        public static const IMPORT_STATEMENT:String = "template.import";
        public static const TEST_INCLUDE:String = "template.testInclude";
        public static const COMPILED_TESTS:String = "template.compiledTests";
        public static const CONNECTION_NAME:String = "template.connection";

        public static function tokenise(token:String):String
        {
            return "\$\{" + token + "\}"
        }

        public static function createTemplatePropertyRegEx(property:String, includeLeadingWhitespace:Boolean):RegExp
        {
            var regExString:String = "(?P<token>\\$\\{" + property + "\\})";
            if(includeLeadingWhitespace)
            {
                regExString = "(?P<whitespace>\\s+)" + regExString;
            }
            return new RegExp(regExString, "g");
        }
    }
}
