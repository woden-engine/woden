selection
selection: aSelection
	aSelection isSelectionBox ifTrue: [
		self useNewSelectionBox: aSelection.
	] ifFalse: [
		self useNewSelectionBox: WTGLevelEditorSelectionBox empty.
		selection := aSelection.
		selection setSelectedState.
	].
	self selectionChanged.