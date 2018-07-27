Extension { #name : #WDGSBrushFace }

{ #category : #'*WodenEngine-LevelEditor' }
WDGSBrushFace >> asNodeModelForLevelEditor: editor [
	editor isFaceSelectMode ifFalse: [ ^ brush asNodeModelForLevelEditor: editor ].
	^ WTGLevelEditorBrushFaceModel new face: self
]
