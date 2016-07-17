actions
addCubeBrushAtSelectionCube
	| brush |
	(selectionBox isEmpty or: [ selectionBox isSpaceSelection not ]) ifTrue: [ ^ self ].
	
	brush := WTGSBrush box: selectionBox box.
	map entities first addComponent: brush.
	
	selectionBox addElement: brush.