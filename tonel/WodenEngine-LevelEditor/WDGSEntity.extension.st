Extension { #name : #WDGSEntity }

{ #category : #'*WodenEngine-LevelEditor' }
WDGSEntity >> asNodeModelForLevelEditor: editor [
	^ WTGLevelEditorEntityModel new entity: self
]
