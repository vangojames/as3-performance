/**
 *
 */
package com.playfish.games.marlin.testing.performance.runner.method
{
    import com.playfish.games.marlin.testing.performance.capture.PerformanceDataEntry;
    import com.playfish.games.marlin.testing.performance.capture.PerformanceTestSet;
    import com.playfish.games.marlin.testing.performance.capture.clearTestSet;
    import com.playfish.games.marlin.testing.performance.capture.retrieveTestSet;
    import com.playfish.games.marlin.testing.performance.meta.configurations.IMethodConfiguration;
    import com.playfish.games.marlin.testing.performance.meta.configurations.SnapshotMethodConfiguration;
    import com.playfish.games.marlin.testing.performance.meta.tags.PerformanceTestMetaTag;
    import com.playfish.games.marlin.testing.performance.runner.async.AsyncToken;
    import com.playfish.games.marlin.testing.performance.runner.helpers.FakeTestClass;

    import org.as3commons.reflect.Method;
    import org.as3commons.reflect.Type;
    import org.hamcrest.assertThat;
    import org.hamcrest.collection.array;
    import org.hamcrest.collection.arrayWithSize;
    import org.hamcrest.core.allOf;
    import org.hamcrest.object.hasProperty;
    import org.hamcrest.object.instanceOf;

    public class TestSnapshotMethodRunner
    {
        private var _runner:SnapshotMethodRunner;
        private var _config:IMethodConfiguration;
        private var _testClass:Class = FakeTestClass;
        private var _testInstance:FakeTestClass = new FakeTestClass();
        private var _testName:String = "myTest";

        [Before]
        public function setup():void
        {
            _config = new SnapshotMethodConfiguration(PerformanceTestMetaTag.TEST);
            var testType:Type = Type.forClass(FakeTestClass);
            for each(var method:Method in testType.methods)
            {
                if(method.name == "testOne")
                {
                    _config.parse(method);
                }
            }
            _runner = new SnapshotMethodRunner();
        }

        [After]
        public function tearDown():void
        {
            clearTestSet(_testClass, _testName);
        }

        [Test]
        public function whenExecuted_givenAllPropertiesCorrect_noSnapshotDataIsStored():void
        {
            _runner.execute(_testClass, _testName, _testInstance, _config, new AsyncToken(this, onComplete, null));
            function onComplete():void
            {
                var testSet:PerformanceTestSet = retrieveTestSet(_testClass, _testName);
                assertThat(testSet.entries, hasProperty("testOne", allOf(arrayWithSize(1), array(instanceOf(PerformanceDataEntry)))));
            }
        }
    }
}
