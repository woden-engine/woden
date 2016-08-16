drawing
renderFramesPerSecondOn: surface canvas: canvas
	| font newRenderTime renderTime fps |
	newRenderTime := DateAndTime millisecondClockValue * 0.001.
	lastRenderTime ifNil: [ lastRenderTime := newRenderTime ].
	renderTime := newRenderTime - lastRenderTime.
	lastRenderTime := newRenderTime.
	(renderTime closeTo: 0.0) ifTrue: [ fps := 0.0 ] ifFalse: [ fps := 1.0 / renderTime ].
	font := engine fontCache default normal pointSize: 14.
	
	canvas setFont: font.
	canvas setPaint: (Color r: 0.0 g: 0.4 b: 0.0).
		
	canvas pathTransform restoreAfter: [
		canvas pathTransform translateX: 10 Y: (font getPreciseAscent).
		canvas drawString: (fps printShowingDecimalPlaces: 3) , ' FPS'.
	]