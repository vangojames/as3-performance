/**
 * Created with IntelliJ IDEA.
 * User: jvango
 * Date: 29/04/12
 * Time: 12:53
 * To change this template use File | Settings | File Templates.
 */
package com.playfish.games.marlin.testing.performance.capture
{
    import flash.display.Sprite;

    import org.flexunit.asserts.assertFalse;
    import org.flexunit.asserts.assertNotNull;
    import org.flexunit.asserts.assertStrictlyEquals;
    import org.flexunit.asserts.assertTrue;

    [RunWith("org.flexunit.runners.Parameterized")]
    public class TestPerformanceRegistry
    {
        // Test against a class an object and null
        public static var targetObjects:Array = [
            [Sprite],
            [new Object()],
            [null]
        ];

        private var _registry:PerformanceRegistry;

        [Before]
        public function setup():void
        {
            _registry = new PerformanceRegistry(new SingletonLock());
        }

        [After]
        public function after():void
        {
            _registry = null;
        }

        [Test(expects="flash.errors.IllegalOperationError")]
        public function whenCreated_givenNotMocked_anErrorIsThrown():void
        {
            var registry:PerformanceRegistry = new PerformanceRegistry();
        }

        [Test]
        public function whenInstanceRequested_ifNotInitialised_singletonReturned():void
        {
            var registry:PerformanceRegistry = PerformanceRegistry.instance;
            assertNotNull(registry);
            assertStrictlyEquals(registry, PerformanceRegistry.instance);
        }

        [Test(dataProvider="targetObjects")]
        public function whenRegistryQueried_givenRepoDoesNotExist_falseIsReturned(targetObject:Object):void
        {
            assertFalse(_registry.contains(targetObject));
        }

        [Test(dataProvider="targetObjects")]
        public function whenRegistryQueried_givenRepoDoesExist_trueIsReturned(targetObject:Object):void
        {
            _registry.retrieve(targetObject);
            assertTrue(_registry.contains(targetObject));
        }

        [Test(dataProvider="targetObjects")]
        public function whenRepoRetrieved_givenRepoDoesExist_aNewOneIsCreated(targetObject:Object):void
        {
            assertNotNull(_registry.retrieve(targetObject));
        }

        [Test(dataProvider="targetObjects")]
        public function whenRepoRetrieved_givenRepoDoesExistAndHasBeenRetrieved_aNewOneIsNotCreated(targetObject:Object):void
        {
            var repo:PerformanceRepository = _registry.retrieve(targetObject);
            assertStrictlyEquals(repo, _registry.retrieve(targetObject));
        }

        [Test(dataProvider="targetObjects")]
        public function whenRepoRemoved_givenRepoDoesNotExist_falseIsReturned(targetObject:Object):void
        {
            assertFalse(_registry.remove(targetObject));
        }

        [Test(dataProvider="targetObjects")]
        public function whenRepoRemoved_givenRepoDoesExist_trueIsReturnedAndRepoIsNoLongerContained(targetObject:Object):void
        {
            _registry.retrieve(targetObject);
            assertTrue(_registry.remove(targetObject));
            assertFalse(_registry.contains(targetObject));
        }

        [Test(dataProvider="targetObjects")]
        public function whenAllReposRemoved_givenRepoDoesExist_repoIsNoLongerContained(targetObject:Object):void
        {
            _registry.retrieve(targetObject);
            _registry.removeAll();
            assertFalse(_registry.contains(targetObject));
        }
    }
}
