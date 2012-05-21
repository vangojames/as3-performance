/**
 *
 */
package com.vango.testing.performance.meta.parse
{
    import com.vango.testing.performance.meta.configurations.IMethodConfiguration;
    import com.vango.testing.performance.meta.configurations.MethodConfiguration;
    import com.vango.testing.performance.meta.configurations.SnapshotMethodConfiguration;
    import com.vango.testing.performance.meta.performance_meta;
    import com.vango.testing.performance.meta.tags.PerformanceTestMetaTag;
    import com.vango.testing.performance.runner.RunConfiguration;

    import flash.system.ApplicationDomain;

    import org.as3commons.reflect.Method;
    import org.as3commons.reflect.Type;

    use namespace performance_meta;

    public class PerformanceTestParser
    {
        /**
         * Parses a test and returns the configurations to run
         * @param test The test to run
         * @return The list of run configurations
         */
        public function parse(test:Class, domain:ApplicationDomain = null):RunConfiguration
        {
            var configuration:RunConfiguration = new RunConfiguration(test);
            var type:Type = Type.forClass(test, domain ? domain : ApplicationDomain.currentDomain);
            var beforeConfigurations:Vector.<IMethodConfiguration> = parseMethods(type, MethodConfiguration, PerformanceTestMetaTag.BEFORE);
            var testConfigurations:Vector.<IMethodConfiguration> = parseMethods(type, SnapshotMethodConfiguration, PerformanceTestMetaTag.TEST);
            var afterConfigurations:Vector.<IMethodConfiguration> = parseMethods(type, MethodConfiguration, PerformanceTestMetaTag.AFTER);
            configuration.configure(beforeConfigurations, testConfigurations, afterConfigurations);
            return configuration;
        }

        /**
         * Parses a the methods for meta data from a type for a particular metatag into a list of test configurations
         * @param from The type to parse from
         * @param to The type to parse to
         * @param metaTag The tage to find
         * @return The parsed list of test configurations
         */
        private function parseMethods(from:Type, to:Class, metaTag:String):Vector.<IMethodConfiguration>
        {
            var input:Vector.<Method> = extractMethodsForMetaData(from, metaTag);
            var l:int = input.length;
            var output:Vector.<IMethodConfiguration> = new Vector.<IMethodConfiguration>(l);

            for(var i:int = 0; i < l; i++)
            {
                var testConfig:IMethodConfiguration = IMethodConfiguration(new to(metaTag));
                testConfig.parse(input[i]);
                output[i] = testConfig;
            }

            return output;
        }

        /**
         * Extract methods for a specific meta key
         * @param type The type to extract from
         * @param key The metadata key to use
         * @return The list of extracted methods
         */
        private function extractMethodsForMetaData(type:Type, key:String):Vector.<Method>
        {
            var matches:Array = type.getMetadataContainers(key);
            var methods:Vector.<Method> = new Vector.<Method>();
            if(matches)
            {
                var l:int = matches.length;
                for(var i:int = 0; i < l; i++)
                {
                    if(matches[i] is Method)
                    {
                        methods.push(matches[i]);
                    }
                }
            }
            return methods;
        }
    }
}
