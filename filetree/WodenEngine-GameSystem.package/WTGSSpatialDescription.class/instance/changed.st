updating
changed
	self recomputeBoundingBox.
	entity ifNil: [ ^ self ].
	entity sceneNodesDo: [:node | node transform: transform ].