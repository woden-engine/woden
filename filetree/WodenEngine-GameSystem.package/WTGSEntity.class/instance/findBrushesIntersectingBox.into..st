as yet unclassified
findBrushesIntersectingBox: box into: collection
	| models |
	models := components at: #modeling ifAbsent: [ ^ self ].
	models do: [ :model |
		(box intersectsOrContainsBox: model boundingBox) ifTrue: [ collection add: model ]
	]