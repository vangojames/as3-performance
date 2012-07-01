/**
 * Created with IntelliJ IDEA.
 * User: jvango
 * Date: 27/04/12
 * Time: 18:55
 * To change this template use File | Settings | File Templates.
 */
package com.vango.testing.performance.capture
{
    import com.vango.testing.performance.reporting.csv.CSV;

    import flash.system.System;
    import flash.utils.Dictionary;
    import flash.utils.getTimer;

    public class PerformanceTestSet
    {
        /**
         * The name of the test set
         */
        public var name:String;

        /**
         * All entries in the test
         */
        public var entries:Dictionary = new Dictionary();

        /**
         * The different test headings
         */
        public var headings:Array = [];

        /**
         * Constructor
         *
         * @param name The name of the set of results
         */
        public function PerformanceTestSet(name:String = "")
        {
            this.name = name;
        }

        /**
         * Takes a snapshot since the last time snapshot was called
         *
         * @param key The key to store the snapshot against
         */
        public function takeSnapshot(testSet:String, time:int = -1, memory:int = -1):PerformanceDataEntry
        {
            var m:int = memory < 0 ? System.totalMemory : memory;
            var t:int = time < 0 ? getTimer() : time;
            if (entries[testSet] == null)
            {
                entries[testSet] = [];
                headings.push(testSet);
            }
            var snapshotData:PerformanceDataEntry = new PerformanceDataEntry(t, m);
            entries[testSet].push(snapshotData);
            return snapshotData;
        }

        /**
         * Returns all the snapshots that were recorded with the specific key
         *
         * @param key The key to use for lookup
         * @return The array of recorded snapshots
         */
        public function retrieveSnapshotsByKey(key:String):Array
        {
            return entries[key];
        }

        /**
         * Removes all the snapshots that were recorded with the specific key
         *
         * @param key The key to use for lookup
         * @return True if any were removed
         */
        public function removeSnapshotsByKey(key:String):Boolean
        {
            if (entries[key])
            {
                delete entries[key];
                headings.splice(headings.indexOf(key), 1);
                return true;
            }
            return false;
        }

        /**
         * Clears all the testing results from the test set
         */
        public function removeAll():void
        {
            entries = new Dictionary();
            headings = [];
        }

        /**
         * Creates a comma separated value list from the test set timing data
         * @param includeHeader Whether to include the key headers at the top of the list
         */
        public function createPerformanceCSV(includeHeader:Boolean):String
        {
            var csv:CSV = new CSV(includeHeader, extractPerformanceEntry);
            return csv.generate(entries, headings);

            // used to extract memory data from each value in the array
            function extractPerformanceEntry(data:PerformanceDataEntry):String
            {
                return data.time.toString();
            }
        }

        /**
         * Creates a comma separated value list from the test set memory data
         * @param includeHeader Whether to include the key headers at the top of the list
         */
        public function createMemoryCSV(includeHeader:Boolean):String
        {
            var csv:CSV = new CSV(includeHeader, extractMemoryEntry);
            return csv.generate(entries, headings);

            // used to extract memoy data from each value in the array
            function extractMemoryEntry(data:PerformanceDataEntry):String
            {
                return data.memory.toString();
            }
        }
    }
}
