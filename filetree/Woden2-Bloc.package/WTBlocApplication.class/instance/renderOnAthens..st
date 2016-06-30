rendering
renderOnAthens: surface
	surface drawDuring: [:canvas |
		mainBlocSpace ifNil: [
			surface clear: Color red.
		] ifNotNil: [
			mainBlocSpace fullDrawOnAthensCanvas: canvas.
		].
		self renderFramesPerSecondOn: surface canvas: canvas.
	].


	