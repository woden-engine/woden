actions
addCubeBrushAtSelectionCube
	| brush |
	(selectionBox isEmpty or: [ selectionBox isSpaceSelection not ]) ifTrue: [ ^ self ].
	
	brush := WTGSBrush box: selectionBox box.
	brush material: currentMaterialName.
	map entities first addComponent: brush.
	
	selectionBox addElement: brush.