as yet unclassified
selectSingleOnEditor: editor
	| newSelection |
	newSelection := WTGLevelEditorSelectionBox empty
		addElement: entity.
	editor selection: newSelection.