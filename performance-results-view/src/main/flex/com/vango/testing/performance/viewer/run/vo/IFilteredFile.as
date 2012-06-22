/**
 *
 */
package com.vango.testing.performance.viewer.run.vo
{
    public interface IFilteredFile
    {
        /**
         * Determines whether the file is valid or not
         */
        function get isValid():Boolean;

        /**
         * Returns a key value list of attributes
         */
        function get attributes():Object;
    }
}
