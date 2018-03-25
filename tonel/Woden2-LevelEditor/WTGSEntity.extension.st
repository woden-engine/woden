Extension { #name : #WTGSEntity }

{ #category : #'*Woden2-LevelEditor' }
WTGSEntity >> asNodeModelForLevelEditor: editor [
	^ WTGLevelEditorEntityModel new entity: self
]
