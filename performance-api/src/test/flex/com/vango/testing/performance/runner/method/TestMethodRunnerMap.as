/**
 *
 */
package com.vango.testing.performance.runner.method
{
    import com.vango.testing.performance.meta.configurations.MethodConfiguration;

    import flash.display.Sprite;

    import org.flexunit.assertThat;
    import org.hamcrest.object.instanceOf;

    public class TestMethodRunnerMap
    {
        [Test(expects=ArgumentError)]
        public function whenMapped_givenWrongConfigType_anErrorIsThrown():void
        {
            var map:MethodRunnerMap = new MethodRunnerMap();
            map.map(Sprite, MethodRunner);
        }

        [Test(expects=ArgumentError)]
        public function whenMapped_givenWrongRunnerType_anErrorIsThrown():void
        {
            var map:MethodRunnerMap = new MethodRunnerMap();
            map.map(MethodConfiguration, Sprite);
        }

        [Test]
        public function whenMapped_givenCorrectType_mappingIsMaintained():void
        {
            var map:MethodRunnerMap = new MethodRunnerMap();
            map.map(MethodConfiguration, MethodRunner);
            var runner:IMethodRunner = map.getMethodRunner(MethodConfiguration);
            assertThat(runner, instanceOf(MethodRunner));
        }

        [Test(expects=Error)]
        public function whenMappedThenDeleted_givenCorrectType_mappingIsRemoved():void
        {
            try
            {
                var map:MethodRunnerMap = new MethodRunnerMap();
                map.map(MethodConfiguration, MethodRunner);
                map.unmap(MethodConfiguration);
            }
            catch(e:Error)
            {
                // Do nothing so test fails if unmapping fails
            }
            var runner:IMethodRunner = map.getMethodRunner(MethodConfiguration);
        }
    }
}
