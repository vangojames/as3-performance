/**
 *
 */
package com.vango.testing.performance.runner.method
{
    import com.vango.testing.performance.capture.retrieveTestSet;
    import com.vango.testing.performance.meta.configurations.IMethodConfiguration;
    import com.vango.testing.performance.meta.configurations.MethodConfiguration;
    import com.vango.testing.performance.meta.tags.PerformanceTestMetaTag;
    import com.vango.testing.performance.runner.async.AsyncToken;
    import com.vango.testing.performance.runner.helpers.FakeTestClass;

    import org.as3commons.reflect.Method;
    import org.as3commons.reflect.Type;
    import org.hamcrest.assertThat;
    import org.hamcrest.collection.emptyArray;

    public class TestMethodRunner
    {
        private var _runner:MethodRunner;
        private var _config:IMethodConfiguration;
        private var _testClass:Class = FakeTestClass;
        private var _testInstance:FakeTestClass = new FakeTestClass();
        private var _testName:String = "myTest";

        [Before]
        public function setup():void
        {
            _config = new MethodConfiguration(PerformanceTestMetaTag.BEFORE);
            var testType:Type = Type.forClass(FakeTestClass);
            for each(var method:Method in testType.methods)
            {
                if(method.name == "beforeOne")
                {
                    _config.parse(method);
                }
            }
            _runner = new MethodRunner();
        }

        [Test]
        public function whenExecuted_givenAllPropertiesCorrect_noSnapshotDataIsStored():void
        {
            _runner.execute(_testClass, _testName, _testInstance, _config, new AsyncToken(this, onComplete, null));
            function onComplete():void
            {
                assertThat(retrieveTestSet(_testClass, _testName).entries, emptyArray());
            }
        }
    }
}
