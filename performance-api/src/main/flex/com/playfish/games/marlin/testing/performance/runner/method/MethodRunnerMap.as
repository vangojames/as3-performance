/**
 *
 */
package com.playfish.games.marlin.testing.performance.runner.method
{
    import com.playfish.games.marlin.testing.performance.meta.configurations.IMethodConfiguration;

    import flash.utils.Dictionary;
    import flash.utils.getQualifiedClassName;

    import org.as3commons.lang.IllegalArgumentError;
    import org.as3commons.reflect.Type;

    public class MethodRunnerMap
    {
        private var _runnerMap:Dictionary = new Dictionary();

        private static const CONFIG_INTERFACE:String = getQualifiedClassName(IMethodConfiguration).replace("::", ".");
        private static const RUNNER_INTERFACE:String = getQualifiedClassName(IMethodRunner).replace("::", ".");

        /**
         * Maps a run configuration type to a method runner type
         * @param configuration The configuration to map
         * @param runner The runner to map to
         */
        public function map(configuration:Class, runner:Class):void
        {
            var configType:Type = Type.forClass(configuration);
            if(configType.interfaces.indexOf(CONFIG_INTERFACE) < 0)
            {
                throw new ArgumentError("Expected configuration to be of type '" +
                        getQualifiedClassName(IMethodConfiguration) + "' but instead received '" +
                        getQualifiedClassName(configuration) + "'.");
            }

            var runnerType:Type = Type.forClass(runner);
            if(runnerType.interfaces.indexOf(RUNNER_INTERFACE) < 0)
            {
                throw new ArgumentError("Expected runner to be of type '" +
                        getQualifiedClassName(IMethodRunner) + "' but instead received '" +
                        getQualifiedClassName(runner) + "'.");
            }
            else
            {
                _runnerMap[configuration] = runner;
            }
        }

        /**
         * Unmaps a run configuration type
         * @param configuration The configuration to unmap
         */
        public function unmap(configuration:Class):void
        {
            delete _runnerMap[configuration];
        }

        /**
         * Retrieves a method runner for a configuration type
         * @param configuration The configuration to get the runner for
         */
        public function getMethodRunner(configuration:Class):IMethodRunner
        {
            var clazz:Class = _runnerMap[configuration] as Class;
            return new clazz() as IMethodRunner;
        }
    }
}
