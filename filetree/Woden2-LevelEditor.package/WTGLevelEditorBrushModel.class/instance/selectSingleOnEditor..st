as yet unclassified
selectSingleOnEditor: editor
	| newSelection |
	newSelection := WTGLevelEditorSelectionBox new
		addElement: brush.
	editor selection: newSelection.