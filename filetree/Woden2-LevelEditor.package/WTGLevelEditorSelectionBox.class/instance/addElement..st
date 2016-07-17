adding
addElement: anElement
	elements add: anElement.
	elements size = 1 ifTrue: [ editor ifNotNil: [ editor selectionBoxView updateColors ] ]