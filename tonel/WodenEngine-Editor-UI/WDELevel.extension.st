Extension { #name : #WDELevel }

{ #category : #'*WodenEngine-Editor-UI' }
WDELevel >> buildContextMenuFor: levelSession on: menuPresenter [
	menuPresenter
		addItem: [:item |
			item
				name: 'New sector';
				action: [
					| newSector oldSelection newSelection |
					newSector := WDESector new.
					oldSelection := levelSession selection.
					newSelection := WDELevelEditorSelection for: {newSector}.
					levelSession
						doWith: [
							self addSector: newSector.
							levelSession selection: newSelection
						]
						undoWith: [
							self removeSector: newSector.
							levelSession selection: oldSelection
						]
				]
		]
]

{ #category : #'*WodenEngine-Editor-UI' }
WDELevel >> openEditor [
	^ self newEditorSession openEditor
]
