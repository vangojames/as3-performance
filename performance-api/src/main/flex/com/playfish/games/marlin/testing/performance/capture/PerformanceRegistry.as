/**
 * Created with IntelliJ IDEA.
 * User: jvango
 * Date: 27/04/12
 * Time: 18:43
 * To change this template use File | Settings | File Templates.
 */
package com.playfish.games.marlin.testing.performance.capture
{
    import flash.errors.IllegalOperationError;
    import flash.utils.Dictionary;

    /**
     * Class used for referencing performance repositories that contain different test set results
     */
    internal class PerformanceRegistry
    {
        /**
         * The static singleton instance of the registry
         */
        public static function get instance():PerformanceRegistry
        {
            if (!_instance)
            {
                _instance = new PerformanceRegistry(new SingletonLock());
            }
            return _instance;
        }

        private static var _instance:PerformanceRegistry;

        /**
         * The number of repositories in the registry
         */
        public function get repositoryCount():int
        {
            return _repositoryCount;
        }

        private var _repositoryCount:int = 0;

        private var _performanceRepositories:Dictionary;

        /**
         * Singleton instance should not be instantiated. Instead use @see com.playfish.games.marlin.testing.performance.capture.PerformanceRegistry.instance
         * @param lock Used to force internal instantiation only
         */
        public function PerformanceRegistry(lock:Object = null)
        {
            if (!(lock is SingletonLock))
            {
                throw new IllegalOperationError("Class cannot be instantiated");
            }
            else
            {
                _performanceRepositories = new Dictionary();
            }
        }

        /**
         * Retrieves a performance repository for the specified target. This is where performance metrics
         * can be added for different tests. If a registry was not previously created then a new one is entered.
         *
         * @param target The object to get a repository for
         * @return The repository linked to the class
         */
        public function retrieve(target:Object):PerformanceRepository
        {
            if (!contains(target))
            {
                _performanceRepositories[target] = new PerformanceRepository(target);
                _repositoryCount++;
            }
            return _performanceRepositories[target];
        }

        /**
         * Determines whether a performance repository has been created for the object
         *
         * @param target The object being tested
         * @return True if a repository has been created for the target object
         */
        public function contains(target:Object):Boolean
        {
            return _performanceRepositories[target] != null;
        }

        /**
         * Removes a performance repository for a specific class
         *
         * @param target The object to remove for
         * @return True if the removal was a success
         */
        public function remove(target:Object):Boolean
        {
            if (contains(target))
            {
                delete _performanceRepositories[target];
                _repositoryCount--;
                return true;
            }
            return false;
        }

        /**
         * Removes all the registered performance repositories
         */
        public function removeAll():void
        {
            _performanceRepositories = new Dictionary();
            _repositoryCount = 0;
        }
    }
}