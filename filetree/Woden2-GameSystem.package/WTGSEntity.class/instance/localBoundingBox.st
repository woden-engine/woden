accessing
localBoundingBox
	self spatialDescription ifNotNil: [ :desc | ^ desc localBoundingBox ].
	^ WMBox3DD nx: -0.1 ny: -0.1 nz: -0.1 px: 0.1 py: 0.1 pz: 0.1