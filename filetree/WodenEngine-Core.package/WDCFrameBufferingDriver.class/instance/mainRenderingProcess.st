rendering process
mainRenderingProcess
	| session targetFrameRate frameStartTime nextFrameTargetTime delayTime lastFrameStartTime frameDeltaTime |
	session := Smalltalk session.
	targetFrameRate := self targetFrameRate.
	lastFrameStartTime := Time microsecondClockValue.
	yieldSemaphore := Semaphore new.
	
	[ session == Smalltalk session ] whileTrue: [
		"Compute the delta"
		frameStartTime := Time microsecondClockValue.
		frameDeltaTime := frameStartTime - lastFrameStartTime.
		lastFrameStartTime := frameStartTime.
	
	
		self swapRenderingProcesses.
		self renderForDeltaMicroseconds: frameDeltaTime.
		frontRenderingProcesses removeAll.
	
		nextFrameTargetTime := frameStartTime + (1000000 / targetFrameRate).
		self flag: 'Support delays in microseconds.'.
		delayTime := (nextFrameTargetTime - Time microsecondClockValue) / 1000.
		
		delayTime > 0 ifTrue: [ 
			(Delay forMilliseconds: delayTime) wait
		] ifFalse: [
			"Allow processing time to the processes with the lower priority"
			self yield
		]
	].