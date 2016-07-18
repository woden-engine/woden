actions
removeSelectedComponents
	selectionBox elements do: [ :element | element removeFromMap ].
	self selectionBox: WTGLevelEditorSelectionBox empty