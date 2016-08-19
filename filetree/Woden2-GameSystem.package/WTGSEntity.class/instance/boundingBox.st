accessing
boundingBox
	self spatialDescription ifNotNil: [ :desc | ^ desc boundingBox ].
	^ self localBoundingBox