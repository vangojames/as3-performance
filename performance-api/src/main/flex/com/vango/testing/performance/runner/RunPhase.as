/**
 *
 */
package com.vango.testing.performance.runner
{
    public class RunPhase
    {
        public static const BEFORE:RunPhase = new RunPhase();
        public static const TEST:RunPhase = new RunPhase();
        public static const AFTER:RunPhase = new RunPhase();
        public static const END:RunPhase = new RunPhase();

        private static var phases:Vector.<RunPhase> = Vector.<RunPhase>([
                BEFORE, TEST, AFTER, END
        ]);

        /**
         * Retrieves the next phase in the list from the phase passed in
         * @return the next phase
         */
        public static function nextPhase(phase:RunPhase):RunPhase
        {
            var index:int = phases.indexOf(phase);
            if(index >= 0)
            {
                index++;
                if(index >= phases.length)
                {
                    index = 0;
                }

                return phases[index];
            }
            else
            {
                throw new Error("Unrecognised phase");
            }
        }
    }
}
