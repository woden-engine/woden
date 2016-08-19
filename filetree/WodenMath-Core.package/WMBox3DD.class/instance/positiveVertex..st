special vertices
positiveVertex: direction
	| vertex |
	vertex := min copy.
	direction x >= 0 ifTrue: [ vertex x: max x ].
	direction y >= 0 ifTrue: [ vertex y: max y ].
	direction z >= 0 ifTrue: [ vertex z: max z ].
	^ vertex