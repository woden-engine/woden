rendering
updateSelectionBoxRenderState
	selectionBoxNode visible: selectionBox isEmpty not.
	
	selectionBoxNode visible ifFalse: [ ^ self ].
	selectionBoxNode transform setForBox: selectionBox.