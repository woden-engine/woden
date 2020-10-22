Extension { #name : #WDELevelEditorSelection }

{ #category : #'*WodenEngine-Editor-UI' }
WDELevelEditorSelection >> buildContextMenuFor: levelSession [
	| presenter |
	presenter := SpMenuPresenter new.
	self buildContextMenuFor: levelSession on: presenter.
	^ presenter

]

{ #category : #'*WodenEngine-Editor-UI' }
WDELevelEditorSelection >> buildContextMenuFor: levelSession on: menuPresenter [
	selectedItems ifEmpty: [
		levelSession buildUnselectedElementContextMenuOn: menuPresenter
	] ifNotEmpty: [
		selectedItems size = 1 ifTrue: [ 
			selectedItems first buildContextMenuFor: levelSession on: menuPresenter
		].
	
		menuPresenter
			addItem: [ :item |
				item
					name: 'Delete';
					action: [ self deleteSelectedItemsInSession: levelSession ]
			];
			addItem: [ :item |
				item
					name: 'Duplicate';
					action: [ self duplicateSelectedItemsInSession: levelSession ]
			].
		(selectedItems allSatisfy: [ :each | each isSectorLayerChild ]) ifTrue: [
			| parentSectorSet |
			parentSectorSet := selectedItems collect: [ :each | each sector ] as: IdentitySet.
			parentSectorSet size = 1 ifTrue: [
				| parentSector |
				parentSector := parentSectorSet anyOne.
				menuPresenter
					addItem: [ :item |
						item
							name: 'Move All to Layer'.
						
					]
			].
		]
	]
]
