Extension { #name : #WDESSimpleUniverse }

{ #category : #'*WodenEngine-Editor-Model' }
WDESSimpleUniverse >> loadSectorsFromEditorLevel: editorLevel [
	editorLevel sectors do: [ :editorSector |
		self buildSector: [ :sector |
			sector loadFromEditorSector: editorSector
		].
	] 
]
