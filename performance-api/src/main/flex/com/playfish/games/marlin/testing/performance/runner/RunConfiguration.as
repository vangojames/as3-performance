/**
 *
 */
package com.playfish.games.marlin.testing.performance.runner
{
    import com.playfish.games.marlin.testing.performance.meta.configurations.*;
    import com.playfish.games.marlin.testing.performance.meta.performance_meta;

    import flash.utils.Dictionary;

    use namespace performance_meta;

    public class RunConfiguration
    {
        /**
         * The test that
         */
        public function get testClass():Class
        {
            return _testClass;
        }
        private var _testClass:Class;

        /**
         * The methods to run before the test to set it up
         */
        public function get beforeMethods():Vector.<IMethodConfiguration>
        {
            return _beforeMethods;
        }
        private var _beforeMethods:Vector.<IMethodConfiguration>;

        /**
         * The methods to run for the test
         */
        public function get testMethods():Vector.<IMethodConfiguration>
        {
            return _testMethods;
        }
        private var _testMethods:Vector.<IMethodConfiguration>;

        /**
         * The methods to run after the test to tear it down
         */
        public function get afterMethods():Vector.<IMethodConfiguration>
        {
            return _afterMethods;
        }
        private var _afterMethods:Vector.<IMethodConfiguration>;

        private var _phaseMethods:Dictionary = new Dictionary();

        /**
         * Constructor
         * @param testClass The test class this relates to
         */
        public function RunConfiguration(testClass:Class)
        {
            _testClass = testClass;
        }

        /**
         * Creates and returns a new test object
         */
        public function createNewTestObject():Object
        {
            return new testClass();
        }

        /**
         * Retrieves the methods for a particular phase
         * @return The methods to retrieve
         */
        public function getMethodsByPhase(phase:RunPhase):Vector.<IMethodConfiguration>
        {
            if(_phaseMethods[phase] == null)
            {
                throw new Error("Unrecognised phase");
            }
            else
            {
                return _phaseMethods[phase];
            }
        }

        /**
         * Configures the run configuration
         * @param before @copy #beforeMethods
         * @param test @copy #testMethods
         * @param after @copy #afterMethods
         */
        performance_meta function configure(before:Vector.<IMethodConfiguration>,
                                    test:Vector.<IMethodConfiguration>,
                                    after:Vector.<IMethodConfiguration>):void
        {
            this._beforeMethods = before.sort(sortByOrder);
            _phaseMethods[RunPhase.BEFORE] = _beforeMethods;
            this._testMethods = test.sort(sortByOrder);
            _phaseMethods[RunPhase.TEST] = _testMethods;
            this._afterMethods = after.sort(sortByOrder);
            _phaseMethods[RunPhase.AFTER] = _afterMethods;
        }

        /**
         * Support function used to sort test configurations by order
         */
        private function sortByOrder(configOne:IMethodConfiguration, configTwo:IMethodConfiguration):int
        {
            var configOneOrder:int = configOne.order;
            var configTwoOrder:int = configTwo.order;
            if(configOneOrder < configTwoOrder)
            {
                return -1;
            }
            else if(configOneOrder > configTwoOrder)
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }
    }
}
