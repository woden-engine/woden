Extension { #name : #WDGSBrush }

{ #category : #'*WodenEngine-LevelEditor' }
WDGSBrush >> asNodeModelForLevelEditor: editor [
	^ WTGLevelEditorBrushModel new brush: self
]
