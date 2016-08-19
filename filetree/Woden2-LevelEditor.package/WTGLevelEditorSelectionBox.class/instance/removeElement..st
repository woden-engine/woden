adding
removeElement: anElement
	super removeElement: anElement.
	elements size = 0 ifTrue: [ editor ifNotNil: [ editor selectionBoxViewsDo: #updateColors ] ].
	self buildBoxFromBoundingBoxes.