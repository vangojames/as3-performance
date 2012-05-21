/**
 * Created with IntelliJ IDEA.
 * User: jvango
 * Date: 30/04/12
 * Time: 10:51
 * To change this template use File | Settings | File Templates.
 */
package com.vango.testing.performance.reporting.csv
{
    import flash.utils.Dictionary;

    import org.flexunit.asserts.assertEquals;
    import org.flexunit.asserts.assertStrictlyEquals;
    import org.flexunit.asserts.assertTrue;
    import org.hamcrest.assertThat;
    import org.hamcrest.collection.hasItems;
    import org.hamcrest.core.not;
    import org.hamcrest.text.containsString;
    import org.hamcrest.text.emptyString;

    public class TestCSV
{
    [Test]
    public function whenCreated_givenInitialValues_valuesAreStored():void
    {
        function testFunction():void{};

        var csv:CSV = new CSV(true, testFunction);
        assertTrue(csv.includeHeader);
        assertStrictlyEquals(csv.extractMethod, testFunction);
    }

    [Test(expects="Error")]
    public function whenGenerated_givenDictionaryWithoutArrayEntries_anErrorIsThrown():void
    {
        var csv:CSV = new CSV(true);
        var data:Dictionary = new Dictionary();
        data["keyOne"] = [];
        data["keyTwo"] = 4;
        csv.generate(data);
    }

    [Test(expects="Error")]
    public function whenGenerated_givenNotEnoughHeadings_anErrorIsThrown():void
    {
        var csv:CSV = new CSV(true);
        var data:Dictionary = new Dictionary();
        data["keyOne"] = [1,2];
        data["keyTwo"] = [3,4];
        csv.generate(data, ["keyOne"]);
    }

    [Test(expects="Error")]
    public function whenGenerated_givenIncorrectHeadings_anErrorIsThrown():void
    {
        var csv:CSV = new CSV(true);
        var data:Dictionary = new Dictionary();
        data["keyOne"] = [1,2];
        data["keyTwo"] = [3,4];
        csv.generate(data, ["nullKeyOne", "nullKeyTwo"]);
    }

    [Test]
    public function whenGenerated_givenEmptyDictionary_emptyStringIsReturned():void
    {
        var csv:CSV = new CSV(true);
        var data:Dictionary = new Dictionary();
        assertThat(csv.generate(data), emptyString());
    }

    [Test]
    public function whenHeaderConstructed_givenDictionaryKeys_allKeysAreInHeading():void
    {
        var csv:CSV = new CSV(true);
        var data:Dictionary = new Dictionary();
        data["keyOne"] = [1,2,3];
        data["keyTwo"] = [4,5,6];
        data["keyThree"] = [7,8,9];

        var dataHeader:Array = csv.constructDataHeader(data);
        assertThat(dataHeader, hasItems("keyOne", "keyTwo", "keyThree"));
    }

    [Test]
    public function whenGenerated_givenNoHeading_noHeadingIsAdded():void
    {
        var csv:CSV = new CSV(false);
        var data:Dictionary = new Dictionary();
        data["keyOne"] = [1,2,3];
        data["keyTwo"] = [4,5,6];
        data["keyThree"] = [7,8,9];

        var dataHeader:String = csv.constructDataHeader(data).join(CSV.DELIM);
        var csvData:String = csv.generate(data);
        assertThat(csvData, not(containsString(dataHeader)));
    }

    [Test]
    public function whenGenerated_givenHeading_headingIsAdded():void
    {
        var csv:CSV = new CSV(true);
        var data:Dictionary = new Dictionary();
        data["keyOne"] = [1,2,3];
        data["keyTwo"] = [4,5,6];
        data["keyThree"] = [7,8,9];

        var dataHeader:String = csv.constructDataHeader(data).join(CSV.DELIM);
        var csvData:String = csv.generate(data);
        assertThat(csvData, containsString(dataHeader));
    }

    [Test]
    public function whenGenerated_givenSpecificHeadingOrder_orderIsMaintained():void
    {
        var csv:CSV = new CSV(false);
        var data:Dictionary = new Dictionary();
        data["keyTwo"] = [4,5,6];
        data["keyOne"] = [1,2,3];
        data["keyThree"] = [7,8,9];

        var csvData:String = csv.generate(data, ["keyTwo", "keyThree", "keyOne"]);
        assertEquals(csvData, "4,7,1\n5,8,2\n6,9,3");
    }

    [Test]
    public function whenGenerated_givenExtractMethod_methodIsCalled():void
    {
        var callbackCount:int = 0;
        function callback(input:String):String
        {
            callbackCount++;
            return input;
        }

        var csv:CSV = new CSV(false, callback);
        var data:Dictionary = new Dictionary();
        data["keyTwo"] = [4,5,6];
        data["keyOne"] = [1,2,3];
        data["keyThree"] = [7,8,9];

        var csvData:String = csv.generate(data);
        assertEquals(callbackCount, 9);
    }

    [Test(expects="Error")]
    public function whenGenerated_givenIncorrectExtractMethodSignature_errorIsThrown():void
    {
        function callback():String
        {
            return "";
        }

        var csv:CSV = new CSV(false, callback);
        var data:Dictionary = new Dictionary();
        data["keyTwo"] = [4,5,6];
        data["keyOne"] = [1,2,3];
        data["keyThree"] = [7,8,9];

        var csvData:String = csv.generate(data);
    }
}
}
