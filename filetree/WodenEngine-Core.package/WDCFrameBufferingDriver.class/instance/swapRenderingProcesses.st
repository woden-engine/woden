rendering process
swapRenderingProcesses
	| temp |
	renderingProcessesLock critical: [
		temp := frontRenderingProcesses.
		frontRenderingProcesses := backRenderingProcesses.
		backRenderingProcesses := temp.
		
		self assert: backRenderingProcesses isEmpty.
		frontRenderingProcesses select: #continousUpdating thenDo: [ :proc |
			backRenderingProcesses add: proc
		]
	].