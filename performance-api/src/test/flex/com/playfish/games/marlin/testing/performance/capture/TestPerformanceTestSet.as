/**
 * Created with IntelliJ IDEA.
 * User: jvango
 * Date: 29/04/12
 * Time: 20:45
 * To change this template use File | Settings | File Templates.
 */
package com.playfish.games.marlin.testing.performance.capture
{
    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertFalse;
    import org.flexunit.asserts.assertNotNull;
    import org.flexunit.asserts.assertNull;
    import org.flexunit.asserts.assertTrue;
    import org.hamcrest.assertThat;
    import org.hamcrest.collection.arrayWithSize;
    import org.hamcrest.collection.hasItems;
    import org.hamcrest.core.not;
    import org.hamcrest.object.hasProperties;
    import org.hamcrest.object.strictlyEqualTo;

    public class TestPerformanceTestSet
{
    private var _performanceSet:PerformanceTestSet;
    private var _setName:String;

    [Before]
    public function setup():void
    {
        _performanceSet = new PerformanceTestSet(_setName = "testSet");
    }

    [After]
    public function tearDown():void
    {
        _performanceSet = null;
    }

    [Test]
    public function whenTestSetCreated_giveName_nameIsCorrect():void
    {
        assertEquals(_setName, _performanceSet.name);
    }

    [Test]
    public function whenTestSetQueried_givenSnapshotDoesNotExist_nullIsReturned():void
    {
        assertNull(_performanceSet.retrieveSnapshotsByKey("methodOne"));
    }

    [Test]
    public function whenTestSetQueried_givenSnapshotDoesExist_correctSnapshotsAreReturned():void
    {
        var returnedSnapshots:Array = [];
        for(var i:int = 0; i < 3; i++)
        {
            returnedSnapshots.push(_performanceSet.takeSnapshot("methodOne"));
        }
        var snapshots:Array = _performanceSet.retrieveSnapshotsByKey("methodOne");
        assertNotNull(snapshots);
        assertThat(snapshots, arrayWithSize(returnedSnapshots.length));
        assertThat(snapshots, hasItems(
                strictlyEqualTo(returnedSnapshots[0]),
                strictlyEqualTo(returnedSnapshots[1]),
                strictlyEqualTo(returnedSnapshots[2])))
    }

    [Test]
    public function whenSnapshotTaken_givenValues_valuesStoredAreCorrect():void
    {
        var t:int = 222;
        var m:int = 1024;
        var data:PerformanceDataEntry = _performanceSet.takeSnapshot("methodOne", t, m);
        assertThat(data, hasProperties({memory:m,  time:t}));
    }

    [Test]
    public function whenSnapshotTaken_givenNoValues_valuesAreNotDefault():void
    {
        var data:PerformanceDataEntry = _performanceSet.takeSnapshot("methodOne");
        assertThat(data, not(hasProperties({memory:-1,  time:-1})));
    }

    [Test]
    public function whenSnapshotsRemoved_givenSnapshotsDoNotExist_falseIsReturned():void
    {
        assertFalse(_performanceSet.removeSnapshotsByKey("methodOne"));
    }

    [Test]
    public function whenSnapshotsRemoved_givenSnapshotsDoExist_trueIsReturned():void
    {
        _performanceSet.takeSnapshot("methodOne");
        assertTrue(_performanceSet.removeSnapshotsByKey("methodOne"));
    }

    [Test]
    public function whenSnapshotsRemoved_givenSnapshotsDoExist_noSnapshotsAreMaintained():void
    {
        _performanceSet.takeSnapshot("methodOne");
        _performanceSet.removeSnapshotsByKey("methodOne");
        assertNull(_performanceSet.retrieveSnapshotsByKey("methodOne"));
    }

    [Test]
    public function whenAllSnapshotsRemoved_givenSnapshotsDoExist_noSnapshotsAreMaintained():void
    {
        _performanceSet.takeSnapshot("methodOne");
        _performanceSet.takeSnapshot("methodTwo");
        _performanceSet.removeAll();
        assertNull(_performanceSet.retrieveSnapshotsByKey("methodOne"), _performanceSet.retrieveSnapshotsByKey("methodTwo"));
    }
}
}
