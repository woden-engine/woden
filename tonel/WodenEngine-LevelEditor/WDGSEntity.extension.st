Extension { #name : #WDGSEntity }

{ #category : #'*WodenEngine-LevelEditor' }
WDGSEntity >> asNodeModelForLevelEditor: editor [
	^ WDGSLevelEditorEntityModel new entity: self
]
