/**
 *
 */
package com.vango.testing.performance.viewer.run.display.tree
{
    import mx.controls.treeClasses.TreeItemRenderer;
    import mx.core.IFactory;

    public class TestTreeItemRendererFactory implements IFactory
    {
        public function newInstance():*
        {
            return new TestItemRendererComponent();
        }
    }
}
