/**
 *
 */
package com.vango.testing.performance.viewer.controls.commands
{
    public class ControlID
    {
        public static const RUN:ControlID = new ControlID("run");
        public static const PROFILE:ControlID = new ControlID("profile");
        public static const COMPARE:ControlID = new ControlID("compare");

        private var _name:String;

        public function ControlID(name:String)
        {
            _name = name;
        }

        public function get name():String
        {
            return _name;
        }
    }
}
