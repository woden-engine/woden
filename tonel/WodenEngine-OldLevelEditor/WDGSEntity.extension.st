Extension { #name : #WDGSEntity }

{ #category : #'*WodenEngine-OldLevelEditor' }
WDGSEntity >> asNodeModelForLevelEditor: editor [
	^ WDGSLevelEditorEntityModel new entity: self
]
