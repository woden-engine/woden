transformations
modifyPositionsApplying: aBlock
	| newPosition |
	1 to: positions size do: [ :i |
		newPosition := aBlock value: (positions at: i).
		positions at: i put: (self roundPosition: newPosition).
	].
	self rebuildPlanes.
	self computeBoundingBox.
	self invalidateModels.