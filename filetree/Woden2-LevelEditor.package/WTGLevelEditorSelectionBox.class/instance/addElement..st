adding
addElement: anElement
	super addElement: anElement.
	box ifNil: [ box := anElement boundingBox copy ]
		ifNotNil: [ box insertBox: anElement boundingBox ].

	editor ifNotNil: [
		elements size = 1 ifTrue: [ editor selectionBoxView updateColors ].
		editor selectionBoxView updateNodes
	]