adding
addRenderProcess: aRenderProcess
	renderingProcessesLock critical: [
		(backRenderingProcesses includes: aRenderProcess) ifFalse: [ 
			backRenderingProcesses add: aRenderProcess
		]
	]