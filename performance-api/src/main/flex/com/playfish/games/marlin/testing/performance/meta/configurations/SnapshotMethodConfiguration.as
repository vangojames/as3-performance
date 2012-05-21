/**
 *
 */
package com.playfish.games.marlin.testing.performance.meta.configurations
{
    import org.as3commons.reflect.Method;

    public class SnapshotMethodConfiguration extends BaseMethodConfiguration
    {
        /**
         * Constructor
         * @param metaTag The metatag defining this method configuration
         */
        public function SnapshotMethodConfiguration(metaTag:String)
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
