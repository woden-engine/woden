adding
addRenderProcess: aRenderProcess
	renderingProcessesLock critical: [
		aRenderProcess suspended: false.
		(backRenderingProcesses includes: aRenderProcess) ifFalse: [
			backRenderingProcesses add: aRenderProcess
		]
	]