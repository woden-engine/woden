rendering
renderOnAthens: surface
	surface drawDuring: [:canvas |
		self renderFramesPerSecondOn: surface canvas: canvas
	]