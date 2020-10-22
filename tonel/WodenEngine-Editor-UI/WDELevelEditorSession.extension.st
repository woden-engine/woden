Extension { #name : #WDELevelEditorSession }

{ #category : #'*WodenEngine-Editor-UI' }
WDELevelEditorSession >> buildSelectionContextMenu [
	^ self selection buildContextMenuFor: self
]

{ #category : #'*WodenEngine-Editor-UI' }
WDELevelEditorSession >> buildUnselectedElementContextMenuOn: menuPresenter [
	menuPresenter
		addItem: [:item |
			item
				name: 'New sector';
				action: [
					| newSector |
					newSector := WDESector new.
					self
						doWith: [ self level addSector: newSector ]
						undoWith: [ self level removeSector: newSector ]
				]
		]
]

{ #category : #'*WodenEngine-Editor-UI' }
WDELevelEditorSession >> openEditor [
	^ (WDELevelEditor on: self) openWithSpec
]
