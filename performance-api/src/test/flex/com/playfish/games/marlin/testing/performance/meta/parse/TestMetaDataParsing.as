/**
 *
 */
package com.playfish.games.marlin.testing.performance.meta.parse
{
    import com.playfish.games.marlin.testing.performance.meta.configurations.SnapshotMethodConfiguration;
    import com.playfish.games.marlin.testing.performance.meta.configurations.MethodConfiguration;
    import com.playfish.games.marlin.testing.performance.meta.helpers.FakeTestWithMethodTags;
    import com.playfish.games.marlin.testing.performance.meta.helpers.FakeTestWithMultipleTagsOnSameMethod;
    import com.playfish.games.marlin.testing.performance.meta.helpers.FakeTestWithNoMetaData;
    import com.playfish.games.marlin.testing.performance.meta.helpers.FakeTestWithPropertyTags;
    import com.playfish.games.marlin.testing.performance.runner.RunConfiguration;

    import org.flexunit.asserts.assertFalse;

    import org.flexunit.asserts.assertTrue;

    import org.hamcrest.assertThat;
    import org.hamcrest.collection.array;
    import org.hamcrest.collection.arrayWithSize;
    import org.hamcrest.collection.emptyArray;
    import org.hamcrest.core.allOf;
    import org.hamcrest.object.equalTo;
    import org.hamcrest.object.hasProperty;
    import org.hamcrest.object.instanceOf;
    import org.hamcrest.object.notNullValue;

    public class TestMetaDataParsing
    {
        [Test]
        public function whenParsed_givenObjectWithNoMetaTags_runConfigurationHasNoTestConfigs():void
        {
            var parser:PerformanceTestParser = new PerformanceTestParser();
            var run:RunConfiguration = parser.parse(FakeTestWithNoMetaData);
            assertThat(run, notNullValue());
            assertThat(run.beforeMethods, emptyArray());
            assertThat(run.testMethods, emptyArray());
            assertThat(run.afterMethods, emptyArray());
        }

        [Test]
        public function whenParsed_givenObjectWithOnlyPropertyMetaTags_runConfigurationHasNoTestConfigs():void
        {
            var parser:PerformanceTestParser = new PerformanceTestParser();
            var run:RunConfiguration = parser.parse(FakeTestWithPropertyTags);
            assertThat(run, notNullValue());
            assertThat(run.beforeMethods, emptyArray());
            assertThat(run.testMethods, emptyArray());
            assertThat(run.afterMethods, emptyArray());
        }

        [Test]
        public function whenParsed_givenObjectWithOneOfEachMethodMetaTags_allTypesAreParsedToCorrectConfigurationClass():void
        {
            var parser:PerformanceTestParser = new PerformanceTestParser();
            var run:RunConfiguration = parser.parse(FakeTestWithMethodTags);
            assertThat(run, notNullValue());
            assertThat(run.beforeMethods,
                    allOf(arrayWithSize(3),
                            array(
                                    instanceOf(MethodConfiguration),
                                    instanceOf(MethodConfiguration),
                                    instanceOf(MethodConfiguration)
                            )
                    ));
            assertThat(run.testMethods,
                    allOf(arrayWithSize(4),
                            array(
                                    instanceOf(SnapshotMethodConfiguration),
                                    instanceOf(SnapshotMethodConfiguration),
                                    instanceOf(SnapshotMethodConfiguration),
                                    instanceOf(SnapshotMethodConfiguration)
                            )
                    ));
            assertThat(run.afterMethods,
                    allOf(arrayWithSize(2),
                            array(
                                    instanceOf(MethodConfiguration),
                                    instanceOf(MethodConfiguration)
                            )
                    ));
        }

        [Test(expects=Error)]
        public function whenParsed_givenObjectWithMultipleStackedMethodMetaTags_anErrorIsThrown():void
        {
            var parser:PerformanceTestParser = new PerformanceTestParser();
            var run:RunConfiguration = parser.parse(FakeTestWithMultipleTagsOnSameMethod);
        }

        [Test]
        public function whenParsed_givenObjectWithOrderedMethods_orderIsMaintained():void
        {
            var parser:PerformanceTestParser = new PerformanceTestParser();
            var run:RunConfiguration = parser.parse(FakeTestWithMethodTags);
            assertThat(run, notNullValue());
            assertThat(run.beforeMethods,
                    array(
                            allOf(hasProperty("order", equalTo(1)), hasProperty("methodName", equalTo("runBeforeOne"))),
                            allOf(hasProperty("order", equalTo(2)), hasProperty("methodName", equalTo("runBeforeTwo"))),
                            allOf(hasProperty("order", equalTo(3)), hasProperty("methodName", equalTo("runBeforeThree")))
                    ));
            assertThat(run.testMethods,
                    array(
                            hasProperty("methodName", equalTo("runTestOne")),
                            hasProperty("methodName", equalTo("runTestTwo")),
                            hasProperty("methodName", equalTo("runTestThree")),
                            hasProperty("methodName", equalTo("runTestFour"))
                    ));
            assertThat(run.afterMethods,
                        array(
                            hasProperty("methodName", equalTo("runAfterOne")),
                            hasProperty("methodName", equalTo("runAfterTwo"))
                        ));
        }

        [Test]
        public function whenParsed_givenObjectWithAsync_asyncIsParsedCorreclty():void
        {
            var parser:PerformanceTestParser = new PerformanceTestParser();
            var run:RunConfiguration = parser.parse(FakeTestWithMethodTags);
            assertTrue(run.testMethods[0].async);
            assertFalse(run.testMethods[1].async);
        }
    }
}
