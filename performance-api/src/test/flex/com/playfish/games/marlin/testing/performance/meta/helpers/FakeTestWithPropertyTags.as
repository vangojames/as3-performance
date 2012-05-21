/**
 *
 */
package com.playfish.games.marlin.testing.performance.meta.helpers
{
    public class FakeTestWithPropertyTags
    {
        [Before]
        public var runBeforeOne:String;
        public function get runBeforeTwo():String
        {
            return "";
        }

        [Before]
        public var runTestOne:String;
        public function get runTestTwo():String
        {
            return "";
        }

        [After]
        public var runAfterOne:String;
        public function get runAfterTwo():String
        {
            return "";
        }
    }
}
