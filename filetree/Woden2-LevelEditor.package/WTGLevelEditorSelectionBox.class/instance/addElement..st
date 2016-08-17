adding
addElement: anElement
	super addElement: anElement.
	elements size = 1 ifTrue: [ editor ifNotNil: [ editor selectionBoxView updateColors ] ]