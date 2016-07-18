as yet unclassified
findBrushesIntersectingSelectedBrushesProperly: selection
	| candidates |
	candidates := self findBrushesIntersectingBox: selection box.
	^ candidates select: [ :brush |
		(selection includes: brush) not and: [ selection intersectsWithBrushProperly: brush ]
	].