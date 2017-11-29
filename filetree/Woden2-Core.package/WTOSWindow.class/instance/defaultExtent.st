factory
defaultExtent
	^ application ifNil: [ 640@480 ] ifNotNil: [ application defaultExtent ]