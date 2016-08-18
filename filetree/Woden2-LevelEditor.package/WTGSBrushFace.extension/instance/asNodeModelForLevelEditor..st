*Woden2-LevelEditor
asNodeModelForLevelEditor: editor
	editor isFaceSelectMode ifFalse: [ ^ brush asNodeModelForLevelEditor: editor ].
	^ WTGLevelEditorBrushFaceModel new face: self