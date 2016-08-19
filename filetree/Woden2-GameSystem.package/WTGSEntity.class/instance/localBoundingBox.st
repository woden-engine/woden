accessing
localBoundingBox
	self spatialDescription ifNotNil: [ :desc | ^ desc localBoundingBox ].
	^ WMBox3DD nx: -0.5 ny: -0.5 nz: -0.5 px: 0.5 py: 0.5 pz: 0.5