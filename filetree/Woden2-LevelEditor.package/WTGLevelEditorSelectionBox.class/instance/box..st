accessing
box: anObject
	box := anObject.
	editor ifNotNil: [ editor selectionBoxView updateNodes ]