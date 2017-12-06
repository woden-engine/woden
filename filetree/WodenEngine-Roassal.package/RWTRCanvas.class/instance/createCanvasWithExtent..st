initialization
createCanvasWithExtent: anExtent
	customSurface ifNotNil: [ ^ customSurface ].
	engine ifNil: [ ^ nil ].
	^ WTAthensSurface engine: engine extent: anExtent