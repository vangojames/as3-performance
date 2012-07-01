package com.vango.testing.performance.viewer.run.services
{
    import flash.display.Sprite;

    public class BasicPerformanceTestExample
    {
        private var _testArray:Array;

        [Before]
        public function setup():void
        {
            _testArray = [];
        }

        [Test]
        public function insertEntries():void
        {
            for(var i:int = 0; i < 1000; i++)
            {
                _testArray.push(new Sprite());
            }
        }

        [Test]
        public function doSomethingElse():void
        {
            for(var i:int = 0; i < 1000; i++)
            {
                _testArray.push(new Sprite());
            }
        }

        [After]
        public function teardown():void
        {
            _testArray = null;
        }
    }
}
