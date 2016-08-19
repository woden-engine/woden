factory
createDrawingProcess
	| shouldContinue |
	controlSemaphore := Semaphore forMutualExclusion.
	drawingProcessFinishSemaphore := Semaphore new. 
	shuttingDown := false.
	^ [
		[
			controlSemaphore critical: [ shouldContinue := shuttingDown not. ].
			shouldContinue ] whileTrue: [ self drawingProcessCycle ].
			drawingProcessFinishSemaphore signal
		] fork "forkAt: Processor lowIOPriority"