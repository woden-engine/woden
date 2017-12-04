as yet unclassified
ensureSpatialDescription
	self spatialDescription ifNil: [ self addComponent: WTGSSpatialDescription new ].