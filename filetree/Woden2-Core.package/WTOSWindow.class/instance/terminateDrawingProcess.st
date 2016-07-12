factory
terminateDrawingProcess
	drawingProcess ifNil: [ ^ self ].
	controlSemaphore critical: [ shuttingDown := true ].
	drawingProcessFinishSemaphore wait.
	