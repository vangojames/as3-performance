/**
 *
 */
package com.vango.testing.performance.runner.helpers
{
    import flash.utils.setTimeout;

    public class FakeAsyncTestClass
    {
        public var runOrder:Vector.<String> = new Vector.<String>();

        [Before(async)]
        public function beforeAsyncOne(onComplete:Function, onFail:Function):void
        {
            setTimeout(onComplete, 200);
            runOrder.push("beforeAsyncOne");
        }

        [Test(async, order=1)]
        public function testAsyncOne(onComplete:Function, onFail:Function):void
        {
            setTimeout(onComplete, 200);
            runOrder.push("testAsyncOne");
        }

        [After(async)]
        public function afterOne(onComplete:Function, onFail:Function):void
        {
            setTimeout(onComplete, 200);
            runOrder.push("afterOne");
        }
    }
}
