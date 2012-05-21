/**
 *
 */
package com.vango.testing.performance.meta.helpers
{
    public class FakeTestWithMultipleTagsOnSameMethod
    {
        [Before]
        [Before]
        public function runBeforeOne():void
        {

        }

        [Test]
        [Test]
        public function runTestOne():void
        {

        }

        [After]
        [After]
        public function runAfterOne():void
        {

        }
    }
}
