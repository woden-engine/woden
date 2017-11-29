as yet unclassified
selectionBoxViewsDo: aBlock
	levelViews do: [ :view |
		view selectionBoxView ifNotNil: [ aBlock value: view selectionBoxView ]
	]