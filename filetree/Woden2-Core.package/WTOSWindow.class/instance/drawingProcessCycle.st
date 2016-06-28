factory
drawingProcessCycle
	| newTime deltaTime startTime endTime wantedCycleTime sleepTime remainingTime |
	lastTime ifNil: [ lastTime := DateAndTime millisecondClockValue * 0.001 ].
	startTime := newTime := DateAndTime millisecondClockValue * 0.001.
	deltaTime := newTime - lastTime.
	lastTime := newTime.
	remainingTime := self updateApplication: deltaTime.
	self frame.
	wantedCycleTime := 1.0 / self maxFPS.
	endTime := DateAndTime millisecondClockValue *0.001.
	"remainingTime > 0 ifTrue: [ wantedCycleTime := wantedCycleTime - remainingTime ]." 
	sleepTime := ((wantedCycleTime - (endTime - startTime)) *1000) asInteger - 2.
	sleepTime > 0 ifTrue: [ (Delay forMilliseconds: sleepTime) wait. ]
