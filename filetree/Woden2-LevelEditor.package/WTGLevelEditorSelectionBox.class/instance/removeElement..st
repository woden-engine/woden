adding
removeElement: anElement
	super removeElement: anElement.
	elements size = 0 ifTrue: [ editor ifNotNil: [ editor selectionBoxView updateColors ] ].
	self buildBoxFromBoundingBoxes.