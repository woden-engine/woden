Extension { #name : #WDESSector }

{ #category : #'*WodenEngine-Editor-UI' }
WDESSector >> loadFromEditorSector: editorSector [
	editorSector layers do: [ :editorLayer |
		editorLayer entities do: [ :editorEntity |
			| entityClass entity |
			entityClass := (editorEntity isPointEntity
				ifTrue: [ WDESPointEntity ]
				ifFalse: [ WDESGenericEntity ]).
			entity := entityClass new.
			self addChild: entity.
			entity
				loadFromEditorEntity: editorEntity .
		]
	]
]
