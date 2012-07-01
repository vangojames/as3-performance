package com.vango.testing.performance.runner.helpers
{
    public class FakeTestClassThatFails
    {
        public function testOne():void
        {
            throw new Error("Expected failure");
        }
    }
}
