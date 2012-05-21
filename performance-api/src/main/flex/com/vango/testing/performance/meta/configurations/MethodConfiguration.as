/**
 *
 */
package com.vango.testing.performance.meta.configurations
{
    import org.as3commons.reflect.Method;

    public class MethodConfiguration extends BaseMethodConfiguration
    {
        /**
         * Constructor
         * @param metaTag The metatag defining this method configuration
         */
        public function MethodConfiguration(metaTag:String)
        {
            super(metaTag);
        }

        /**
         * @inheritDoc
         */
        protected override function applyCustomParsing(method:Method):void
        {

        }
    }
}
