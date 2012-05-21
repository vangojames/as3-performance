/**
 *
 */
package com.vango.testing.performance.meta.configurations
{
    import com.vango.testing.performance.meta.tags.PerformanceTestMetaAttribute;

    import org.as3commons.reflect.Metadata;
    import org.as3commons.reflect.MetadataArgument;
    import org.as3commons.reflect.Method;

    public class BaseMethodConfiguration implements IMethodConfiguration
    {
        /**
         * @inheritDoc
         */
        public function get methodName():String
        {
            return _methodName;
        }
        private var _methodName:String;

        /**
         * @inheritDoc
         */
        public function get order():int
        {
            return _order;
        }
        private var _order:int;

        /**
         * @inheritDoc
         */
        public function get async():Boolean
        {
            return _async;
        }
        private var _async:Boolean;

        /**
         * The metadata tag to use for this configuration
         */
        protected function get metaTag():String
        {
            return _metaTag;
        }
        private var _metaTag:String;

        /**
         * Constructor
         * @param metaTag The metatag defining this method configuration
         */
        public function BaseMethodConfiguration(metaTag:String)
        {
            _metaTag = metaTag;
        }

        /**
         * @inheritDoc
         */
        public final function parse(method:Method):void
        {
            // store the test name
            _methodName = method.name;

            var metaDataList:Array = method.getMetadata(metaTag);
            if(metaDataList == null)
            {
                throw new Error("Method '" + _methodName + "' is missing annotation for '" + metaTag + "'");
            }
            if(metaDataList.length != 1)
            {
                throw new Error("Expected only one metadata entry for '" + metaTag + "'");
            }
            else
            {
                parseDefaultMetadata(metaDataList[0] as Metadata);
            }

            // parses any custom parsing required
            applyCustomParsing(method);
        }

        /**
         * Parses the default metadata from the configuration
         */
        private function parseDefaultMetadata(metaData:Metadata):void
        {
            var orderString:String = parseMetaAttribute(metaData, PerformanceTestMetaAttribute.ORDER, "0");
            _order = parseInt(orderString);
            var asyncString:String = parseMetaAttribute(metaData, PerformanceTestMetaAttribute.ASYNC, "false");
            _async = asyncString.toLowerCase() != "false";
        }

        /**
         * Applies any custom parsing that is required
         */
        protected function applyCustomParsing(method:Method):void
        {
            throw new Error("Method not implemented");
        }

        /**
         * Parses an attribute from metadata to a specific type. If the attribute does not exist then the default value
         * is returned. If the attribute does exist but has no value, then true is returned
         * @param metaData The metadata to parse from
         * @param metaAtt The attribute key to parse
         * @param type The type to parse to
         * @param defaultValue The default value to use if the attribute is not set
         * @return The parsed value
         */
        protected function parseMetaAttribute(metaData:Metadata, metaAtt:String, defaultValue:String):String
        {
            for each(var arg:MetadataArgument in metaData.arguments)
            {
                if(arg.value == metaAtt && arg.key == "")
                {
                    return "true";
                }
                else if(arg.key == metaAtt)
                {
                    if(arg.value != "")
                    {
                        return arg.value;
                    }
                    else
                    {
                        return "true";
                    }
                }
            }

            return defaultValue;
        }
    }
}
