Extension { #name : #WDESector }

{ #category : #'*WodenEngine-Editor-UI' }
WDESector >> buildContextMenuFor: levelSession on: menuPresenter [
	menuPresenter
		addItem: [:item |
			item
				name: 'New sector layer';
				action: [
					| newLayer |
					newLayer := WDESectorLayer new.
					levelSession
						doWith: [ self addLayer: newLayer ]
						undoWith: [ self removeLayer: newLayer ]
				]
		]
]
