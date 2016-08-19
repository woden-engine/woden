adding
buildBoxFromBoundingBoxes
	box := WMBox3DD empty.
	elements do: [ :element | box insertBox: element boundingBox ].
	editor ifNotNil: [ editor selectionBoxViewsDo: #updateNodes ]