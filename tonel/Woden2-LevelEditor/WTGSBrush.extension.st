Extension { #name : #WTGSBrush }

{ #category : #'*Woden2-LevelEditor' }
WTGSBrush >> asNodeModelForLevelEditor: editor [
	^ WTGLevelEditorBrushModel new brush: self
]
