special vertices
negativeVertex: direction
	| vertex |
	vertex := max copy.
	direction x >= 0 ifTrue: [ vertex x: min x ].
	direction y >= 0 ifTrue: [ vertex y: min y ].
	direction z >= 0 ifTrue: [ vertex z: min z ].
	^ vertex