Extension { #name : #WDGSBrushFace }

{ #category : #'*WodenEngine-OldLevelEditor' }
WDGSBrushFace >> asNodeModelForLevelEditor: editor [
	editor isFaceSelectMode ifFalse: [ ^ brush asNodeModelForLevelEditor: editor ].
	^ WDGSLevelEditorBrushFaceModel new face: self
]
