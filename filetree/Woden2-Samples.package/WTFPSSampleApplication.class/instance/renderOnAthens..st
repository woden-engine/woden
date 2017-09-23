rendering
renderOnAthens: surface
	surface drawDuring: [:canvas |
		self computeFPS.
		stereoMode ifTrue: [ 
			canvas pathTransform restoreAfter: [
				self renderFramesPerSecondOn: surface canvas: canvas
			].
			canvas pathTransform restoreAfter: [
				canvas pathTransform translateBy: surface extent x // 2 @0.
				self renderFramesPerSecondOn: surface canvas: canvas
			]
		] ifFalse: [ 
			self renderFramesPerSecondOn: surface canvas: canvas
		]
	]