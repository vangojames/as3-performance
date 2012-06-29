/**
 *
 */
package com.vango.testing.performance.viewer.run.display.list
{
    import mx.core.IFactory;

    public class SourceListItemRendererFactory implements IFactory
    {
        public function newInstance():*
        {
            return new SourceItemRendererComponent();
        }
    }
}
