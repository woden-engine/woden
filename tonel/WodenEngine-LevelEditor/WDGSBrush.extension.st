Extension { #name : #WDGSBrush }

{ #category : #'*WodenEngine-LevelEditor' }
WDGSBrush >> asNodeModelForLevelEditor: editor [
	^ WDGSLevelEditorBrushModel new brush: self
]
