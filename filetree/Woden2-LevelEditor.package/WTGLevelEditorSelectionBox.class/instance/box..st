accessing
box: anObject
	box := anObject.
	editor ifNotNil: [ editor selectionBoxViewsDo: #updateNodes ]