rendering
computeFPS
	| newRenderTime renderTime |
	newRenderTime := DateAndTime millisecondClockValue * 0.001.
	lastRenderTime ifNil: [ lastRenderTime := newRenderTime ].
	renderTime := newRenderTime - lastRenderTime.
	lastRenderTime := newRenderTime.
	(renderTime closeTo: 0.0) ifTrue: [ fps := 0.0 ] ifFalse: [ fps := 1.0 / renderTime ].
