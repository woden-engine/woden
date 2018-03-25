Extension { #name : #WTGSBrushFace }

{ #category : #'*Woden2-LevelEditor' }
WTGSBrushFace >> asNodeModelForLevelEditor: editor [
	editor isFaceSelectMode ifFalse: [ ^ brush asNodeModelForLevelEditor: editor ].
	^ WTGLevelEditorBrushFaceModel new face: self
]
