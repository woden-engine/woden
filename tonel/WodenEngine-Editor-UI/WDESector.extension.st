Extension { #name : #WDESector }

{ #category : #'*WodenEngine-Editor-UI' }
WDESector >> buildContextMenuFor: levelSession on: menuPresenter [
	menuPresenter
		addItem: [:item |
			item
				name: 'New sector layer';
				action: [
					| newLayer oldSelection newSelection |
					newLayer := WDESectorLayer new.
					oldSelection := levelSession selection.
					newSelection := WDELevelEditorSelection for: {newLayer}.
					levelSession
						doWith: [
							self addLayer: newLayer.
							levelSession selection: newSelection
						]
						undoWith: [
							self removeLayer: newLayer.
							levelSession selection: oldSelection
						]
				]
		]
]
