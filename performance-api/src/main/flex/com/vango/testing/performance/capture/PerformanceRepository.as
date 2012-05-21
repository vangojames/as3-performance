/**
 * Created with IntelliJ IDEA.
 * User: jvango
 * Date: 27/04/12
 * Time: 18:45
 * To change this template use File | Settings | File Templates.
 */
package com.vango.testing.performance.capture
{
    import flash.utils.Dictionary;

    internal class PerformanceRepository
    {
        /**
         * The number of test sets in the repository
         */
        public function get testSetCount():int
        {
            return _testSetCount;
        }

        private var _testSetCount:int = 0;

        public var target:Object;
        private var _testSet:Dictionary = new Dictionary();

        /**
         * Constructor
         *
         * @param target The object that this repository will hold data for
         */
        public function PerformanceRepository(target:Object)
        {
            this.target = target;
        }

        /**
         * Retrieves the test set with the specified name. If the set doesn't exist then a new one is created
         *
         * @param name The name of the test set
         * @return The newly generated test set
         */
        public function retrieveTestSet(name:String):PerformanceTestSet
        {
            if (!containsTestSet(name))
            {
                _testSet[name] = new PerformanceTestSet(name);
                _testSetCount++;
            }

            return _testSet[name];
        }

        /**
         * Determines whether a test set exists with the specified name
         *
         * @param name the name of the test set
         * @return True if the test set exists
         */
        public function containsTestSet(name:String):Boolean
        {
            return _testSet[name] != null;
        }

        /**
         * Removes a test set from the repository
         * @param name The name of the test set
         * @return True if the test set was removed succesfully
         */
        public function removeTestSet(name:String):Boolean
        {
            if (containsTestSet(name))
            {
                delete _testSet[name];
                _testSetCount--;
                return true;
            }
            return false;
        }

        /**
         * Removes all the test sets from the testing repository
         */
        public function removeAllTestSets():void
        {
            _testSet = new Dictionary();
            _testSetCount = 0;
        }
    }
}
