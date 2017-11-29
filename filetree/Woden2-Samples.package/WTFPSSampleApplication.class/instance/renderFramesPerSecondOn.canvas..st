rendering
renderFramesPerSecondOn: surface canvas: canvas
	| font |
	font := engine fontCache default normal pointSize: 14.
	
	canvas setFont: font.
	canvas setPaint: (Color r: 0.0 g: 0.4 b: 0.0).
		
	canvas pathTransform restoreAfter: [
		canvas pathTransform translateX: 10 Y: (font getPreciseAscent).
		canvas drawString: (fps printShowingDecimalPlaces: 3) , ' FPS'.
	]