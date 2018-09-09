Extension { #name : #WDCMaterial }

{ #category : #'*WodenEngine-LevelEditor' }
WDCMaterial >> inEditor: editor addObjectAtSelectionCube: selectionBox [
	^ editor addActiveBrushTypeAtSelectionCube
]
