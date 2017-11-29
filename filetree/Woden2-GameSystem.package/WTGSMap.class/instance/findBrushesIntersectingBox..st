as yet unclassified
findBrushesIntersectingBox: box
	| brushes |
	brushes := OrderedCollection new.
	entities do: [ :entity |
		entity findBrushesIntersectingBox: box into: brushes
	].

	^ brushes