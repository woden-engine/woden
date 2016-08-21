map events
simulateTime: delta
	| camera |
	super simulateTime: delta.
	camera := self levelPlayer camera.
	camera ifNotNil: [
		camera transform: (self entity spatialDescription
		transform asWMReversibleAffineTransformF
			translateByY: self class eyePosition)]