package com.vango.testing.performance.viewer.run.services.running
{
    import flash.desktop.NativeProcess;
    import flash.desktop.NativeProcessStartupInfo;
    import flash.events.NativeProcessExitEvent;
    import flash.filesystem.File;
    import flash.net.LocalConnection;

    public class AS3RunningService
    {
        private var _connection:LocalConnection;
        private var _client:TestHarnessClient;
        private var _runProcess:NativeProcess;

        /**
         * Runs a swf and listens to the ouput
         * @param path The path to the swf
         * @param connectionName The name of the connection of the swf
         */
        public function run(player:File, path:File, connectionName:String):void
        {
            _connection = new LocalConnection();
            _connection.allowDomain("*");
            _connection.allowInsecureDomain("*");
            _connection.connect(connectionName);
            _client = new TestHarnessClient();
            _connection.client = _client;

            _client.onTestComplete.add(onTestsCompleted);
            _client.onTestFailed.add(onTestsFailed);
            _client.onAllTestsComplete.add(onAllTestsComplete);

            var runOptions:NativeProcessStartupInfo = new NativeProcessStartupInfo();
            runOptions.executable = player;
            runOptions.arguments = Vector.<String>([path.nativePath]);

            _runProcess = new NativeProcess();
            _runProcess.addEventListener(NativeProcessExitEvent.EXIT, onExit);
            _runProcess.start(runOptions);
        }

        private function onTestsCompleted():void
        {
            trace("Tests completed succesfully");
        }

        private function onTestsFailed():void
        {
            trace("Test failed");
        }

        private function onAllTestsComplete():void
        {
            trace("All tests finished");
            _runProcess.removeEventListener(NativeProcessExitEvent.EXIT, onExit);
            _runProcess.exit();
        }

        private function onExit(event:NativeProcessExitEvent):void
        {
            trace("player was closed before tests could be completed")
        }
    }
}
