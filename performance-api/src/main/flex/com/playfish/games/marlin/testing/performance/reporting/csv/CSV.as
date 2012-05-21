/**
 * Created with IntelliJ IDEA.
 * User: jvango
 * Date: 30/04/12
 * Time: 09:48
 * To change this template use File | Settings | File Templates.
 */
package com.playfish.games.marlin.testing.performance.reporting.csv
{
    import flash.errors.IllegalOperationError;
    import flash.utils.Dictionary;
    import flash.utils.getQualifiedClassName;

    public class CSV
    {
        public var includeHeader:Boolean;
        public var extractMethod:Function;

        internal static const DELIM:String = ",";
        internal static const LINE_END:String = "\n";

        /**
         * Extracts data for a CSV from a dictionary using the keys for the dictionary as the method column name
         * and the associated array entry as the column values. If an exractMethod is specified then this is used
         * on the object to extract the data for the CSV otherwise the entry is cast to a string.
         * @param data
         * @param includeHeader
         * @param extractMethod
         */
        public function CSV(includeHeader:Boolean, extractMethod:Function = null)
        {
            this.includeHeader = includeHeader;
            this.extractMethod = extractMethod;
        }

        /**
         * Extracts data for a CSV from a dictionary using the keys for the dictionary as the method column name
         * and the associated array entry as the column values. If an exractMethod was specified then this is used
         * on each object in the array to extract the data for the CSV otherwise the entry is cast to a string.
         * @param data The dictionary object to extract the data from
         * @param headingOrder The order to extract headings in. If null then the dictionary order is used
         * @return the parsed CSV data
         */
        public function generate(data:Dictionary, headingOrder:Array = null):String
        {
            var rowCount:int = 0;
            var columnCount:int = 0;

            // check all info in the dictionary is an array and extract the largest array length as the row length
            for (var k:Object in data)
            {
                if (!(data[k] is Array))
                {
                    throw new IllegalOperationError("Expected all entries in the dictionary to be arrays but found '" +
                            getQualifiedClassName(data[k]) + "' referenced by key '" + k + "' instead");
                }
                else
                {
                    if (rowCount < (data[k] as Array).length)
                    {
                        rowCount = (data[k] as Array).length;
                    }
                    columnCount++;
                }
            }

            // setup extract method
            if (extractMethod == null)
            {
                extractMethod = parseObjectToString;
            }
            else
            {
                if (extractMethod.length != 1)
                {
                    throw new Error("Expecting exraction method to take a single Object and return a String");
                }
            }

            // setup heading order
            if (headingOrder == null)
            {
                headingOrder = constructDataHeader(data);
            }
            else if (headingOrder.length != columnCount)
            {
                throw new Error("There are not enough headings for the different columns found in the dictionary");
            }

            // If there are no headings then there is no data so return an empty string
            if (headingOrder.length == 0)
            {
                return "";
            }

            // generate the CSV
            var csvData:Array = [];
            if (includeHeader)
            {
                csvData.push(headingOrder.join(DELIM));
            }
            for (var i:int = 0; i < rowCount; i++)
            {
                var rowData:Array = [];
                for (var j:int = 0; j < columnCount; j++)
                {
                    var columnName:Object = headingOrder[j];
                    if (data[columnName] == null)
                    {
                        throw new Error("Column not found for heading '" + columnName + "'");
                    }
                    var column:Array = data[columnName];
                    var columnLength:int = column.length;

                    if (i < columnLength)
                    {
                        rowData.push(extractMethod(column[i]));
                    }
                    else
                    {
                        rowData.push("");
                    }
                }
                csvData.push(rowData.join(DELIM));
            }
            return csvData.join(LINE_END);
        }

        /**
         * Retrieves the heading for a dictionary and fills up a heading list
         * @param data The data list to extract the heading from
         * @return The header data
         */
        internal function constructDataHeader(data:Dictionary):Array
        {
            var headerList:Array = [];
            for (var k:Object in data)
            {
                headerList.push(k);
            }
            return headerList;
        }

        /**
         * Parses an object to string
         * @param target The target object to parse
         * @return The string epresentation of the target
         */
        private function parseObjectToString(target:*):String
        {
            return String(target);
        }
    }
}
