actions
removeSelectedComponents
	selection elements do: [ :element | element removeFromMap ].
	self selection: WTGLevelEditorSelectionBox empty