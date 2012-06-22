/**
 *
 */
package com.vango.testing.performance.viewer.run.vo
{
    public class FilteredTestFile implements IFilteredFile
    {
        public function get isValid():Boolean
        {
            return _isValid;
        }
        private var _isValid:Boolean;

        public function get attributes():Object
        {
            return _attributes;
        }
        private var _attributes:Object;

        public function FilteredTestFile()
        {

        }

        public function set attributes(value:Object):void
        {
            _attributes = value;
        }

        public function set isValid(value:Boolean):void
        {
            _isValid = value;
        }
    }
}
