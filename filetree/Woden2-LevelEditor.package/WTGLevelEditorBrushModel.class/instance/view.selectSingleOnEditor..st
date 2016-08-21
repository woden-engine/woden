as yet unclassified
view: view selectSingleOnEditor: editor
	| newSelection |
	newSelection := WTGLevelEditorSelectionBox new
		addElement: brush.
	editor selection: newSelection.