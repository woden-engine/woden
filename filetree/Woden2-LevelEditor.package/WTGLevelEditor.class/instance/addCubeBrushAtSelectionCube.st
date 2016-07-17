initialization
addCubeBrushAtSelectionCube
	| brush |
	selectionBox isEmpty ifTrue: [ ^ self ].
	
	brush := WTGSBrush box: selectionBox.
	map entities first addComponent: brush.