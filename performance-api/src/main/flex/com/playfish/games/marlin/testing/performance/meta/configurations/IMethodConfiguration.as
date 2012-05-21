/**
 *
 */
package com.playfish.games.marlin.testing.performance.meta.configurations
{
    import org.as3commons.reflect.Method;

    public interface IMethodConfiguration
    {
        /**
         * The method name of the test
         */
        function get methodName():String;

        /**
         * The order to run this test
         */
        function get order():int;

        /**
         * Determines whether this method is fired asynchronously or not
         */
        function get async():Boolean

        /**
         * Parses the configuration from a method
         * @param method The method to parse from
         */
        function parse(method:Method):void;
    }
}
