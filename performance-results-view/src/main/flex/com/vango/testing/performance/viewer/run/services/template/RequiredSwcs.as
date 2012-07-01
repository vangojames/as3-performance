package com.vango.testing.performance.viewer.run.services.template
{
    public class RequiredSwcs
    {
        [Embed(source="../../../../../../../../../resources/requiredSwcs/performance-api-0.0.0.0-SNAPSHOT.swc", mimeType="application/octet-stream")]
        public static const TEST_API:Class;
        [Embed(source="../../../../../../../../../resources/requiredSwcs/as3-signals-0.9-BETA.swc", mimeType="application/octet-stream")]
        public static const SIGNALS_API:Class;
        [Embed(source="../../../../../../../../../resources/requiredSwcs/as3commons-reflect-1.6.0.swc", mimeType="application/octet-stream")]
        public static const REFLECTION_API:Class;
    }
}
