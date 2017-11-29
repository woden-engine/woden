computing
localBoundingBox
	^ renderable ifNil: [ shape boundingBoxFor: self ] ifNotNil: [ renderable boundingBox ]