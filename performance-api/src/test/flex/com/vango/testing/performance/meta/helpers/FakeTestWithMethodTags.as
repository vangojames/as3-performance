/**
 *
 */
package com.vango.testing.performance.meta.helpers
{
    public class FakeTestWithMethodTags
    {
        [Before(order=1)]
        public function runBeforeOne():void
        {

        }

        [Before(order=2)]
        public function runBeforeTwo():void
        {

        }

        [Before(order=3)]
        public function runBeforeThree():void
        {

        }

        [Test(order=2)]
        public function runTestTwo():void
        {

        }

        [Test(order=1, async)]
        public function runTestOne():void
        {

        }

        [Test(order=4)]
        public function runTestFour():void
        {

        }

        [Test(order=3)]
        public function runTestThree():void
        {

        }

        [After]
        public function runAfterOne():void
        {

        }

        [After(order=1)]
        public function runAfterTwo():void
        {

        }
    }
}
