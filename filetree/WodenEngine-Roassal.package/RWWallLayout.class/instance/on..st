public
on: aCollection
	| elemenets bricksPerSide maxDimension positions layer actionBlock bricksInLayer |
	elemenets := aCollection asOrderedCollection.
	bricksPerSide := self elementsPerSideForElements: elemenets size.
	bricksInLayer := (bricksPerSide - 1) * 4 max: 1.
	maxDimension := self computeMaximumDimension: elemenets.
	positions := self
		positionsFor: maxDimension
		onLayerSized: bricksPerSide.
	
	layer := 0.	
	actionBlock := [ :el :index |
		el
			translateToX: (positions at: index) x
			           y: layer * maxDimension y
			           z: (positions at: index) y ].
	
	elemenets
		groupsOf: bricksInLayer
		atATimeDo: [ :els | 
			els withIndexDo: actionBlock.
			layer := layer + 1 ].
	(elemenets allButFirst: layer * bricksInLayer) withIndexDo: actionBlock