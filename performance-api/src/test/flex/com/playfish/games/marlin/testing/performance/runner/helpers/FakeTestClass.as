/**
 *
 */
package com.playfish.games.marlin.testing.performance.runner.helpers
{
    public class FakeTestClass
    {
        public var runOrder:Vector.<String> = new Vector.<String>();

        public var beforeCount:int = 0;
        public var testCount:int = 0;
        public var afterCount:int = 0;

        [Before]
        public function beforeOne():void
        {
            beforeCount++;
            runOrder.push("beforeOne");
        }

        [Test(order=1)]
        public function testOne():void
        {
            for(var i:int = 0; i < 10000; i++)
            {
                new Object();
                testCount++;
            }
            runOrder.push("testOne");
        }

        [Test(order=2)]
        public function testTwo():void
        {
            testCount++;
            runOrder.push("testTwo");
        }

        [After]
        public function afterOne():void
        {
            afterCount++;
            runOrder.push("afterOne");
        }
    }
}
