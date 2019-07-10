Extension { #name : #WDCMaterial }

{ #category : #'*WodenEngine-OldLevelEditor' }
WDCMaterial >> inEditor: editor addObjectAtSelectionCube: selectionBox [
	^ editor addActiveBrushTypeAtSelectionCube
]
