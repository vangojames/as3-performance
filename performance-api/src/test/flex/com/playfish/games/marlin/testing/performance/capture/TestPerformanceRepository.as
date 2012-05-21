/**
 * Created with IntelliJ IDEA.
 * User: jvango
 * Date: 29/04/12
 * Time: 17:47
 * To change this template use File | Settings | File Templates.
 */
package com.playfish.games.marlin.testing.performance.capture
{
import org.flexunit.asserts.assertEquals;
import org.flexunit.asserts.assertFalse;
import org.flexunit.asserts.assertStrictlyEquals;
import org.flexunit.asserts.assertTrue;

public class TestPerformanceRepository
{
    private var _repository:PerformanceRepository;
    private var _targetObject:Object;

    [Before]
    public function setup():void
    {
        _repository = new PerformanceRepository(_targetObject = new Object());
    }

    [After]
    public function tearDown():void
    {
        _repository = null;
        _targetObject = null;
    }

    [Test]
    public function whenRepositoryCreated_givenTarget_targetIsStored():void
    {
        assertStrictlyEquals(_repository.target, _targetObject);
    }

    [Test]
    public function whenTestSetRetrieved_givenSetDoesNotExist_setIsCreated():void
    {
        _repository.retrieveTestSet("myTestSet");
        assertTrue(_repository.containsTestSet("myTestSet"));
    }

    [Test]
    public function whenTestSetRetrieved_givenSetDoesExist_setIsNotCreated():void
    {
        var set:PerformanceTestSet = _repository.retrieveTestSet("myTestSet");
        assertStrictlyEquals(_repository.retrieveTestSet("myTestSet"), set);
    }

    [Test]
    public function whenRepositoryQueried_givenSetDoesNotExist_queryReturnsFalse():void
    {
        assertFalse(_repository.containsTestSet("myTestSet"));
    }

    [Test]
    public function whenRepositoryQueried_givenSetDoesExist_queryReturnsTrue():void
    {
        _repository.retrieveTestSet("myTestSet");
        assertTrue(_repository.containsTestSet("myTestSet"));
    }

    [Test]
    public function whenTestSetRemoved_givenSetDoesNotExist_returnsFalse():void
    {
        assertFalse(_repository.removeTestSet("myTestSet"));
    }

    [Test]
    public function whenTestSetRemoved_givenSetDoesExist_returnsTrue():void
    {
        _repository.retrieveTestSet("myTestSet");
        assertTrue(_repository.removeTestSet("myTestSet"));
    }

    [Test]
    public function whenTestAllSetsRemoved_givenSetDoesExist_setIsNoLongerContained():void
    {
        _repository.retrieveTestSet("myTestSet");
        _repository.removeAllTestSets();
        assertFalse(_repository.containsTestSet("myTestSet"));
    }

    [Test]
    public function whenNoTestSetsAdded_countIsZero():void
    {
        assertEquals(_repository.testSetCount, 0);
    }

    [Test]
    public function whenTestSetsAdded_countIsAccurate():void
    {
        for(var i:int = 0; i < 3; i++)
        {
            _repository.retrieveTestSet("set" + i.toString());
        }
        assertEquals(_repository.testSetCount, 3);
    }

    [Test]
    public function whenTestSetsRemoved_countIsAccurate():void
    {
        for(var i:int = 0; i < 3; i++)
        {
            _repository.retrieveTestSet("set" + i.toString());
        }
        _repository.removeTestSet("set0");
        _repository.removeTestSet("set1");
        assertEquals(_repository.testSetCount, 1);
    }
}
}
