selection
clearSelection
	faceSelectMode
		ifTrue: [ self selection: WTGLevelEditorSelection new. ]
		ifFalse: [ self selection: WTGLevelEditorSelectionBox empty. ]
	