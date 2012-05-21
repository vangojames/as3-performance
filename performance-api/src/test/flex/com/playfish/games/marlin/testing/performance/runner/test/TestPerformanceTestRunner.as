/**
 *
 */
package com.playfish.games.marlin.testing.performance.runner.test
{
    import com.playfish.games.marlin.testing.performance.capture.clearTestSet;
    import com.playfish.games.marlin.testing.performance.runner.helpers.FakeTestClass;

    import org.osflash.signals.utils.proceedOnSignal;

    public class TestPerformanceTestRunner
    {
        private var runner:PerformanceTestRunner;

        [Before]
        public function setup():void
        {
            runner = new PerformanceTestRunner();
        }

        [After]
        public function tearDown():void
        {
            runner = null;
            clearTestSet(FakeTestClass, "myTest");
        }

        [Test(async)]
        public function testRunner():void
        {
            proceedOnSignal(this, runner.onComplete, 100000);
            runner.run(FakeTestClass, "myTest", 100);
        }
    }
}