Extension { #name : #WDGSBrushFace }

{ #category : #'*WodenEngine-LevelEditor' }
WDGSBrushFace >> asNodeModelForLevelEditor: editor [
	editor isFaceSelectMode ifFalse: [ ^ brush asNodeModelForLevelEditor: editor ].
	^ WDGSLevelEditorBrushFaceModel new face: self
]
