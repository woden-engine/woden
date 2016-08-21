as yet unclassified
view: view selectSingleOnEditor: editor
	| newSelection |
	newSelection := WTGLevelEditorSelectionBox empty
		addElement: entity.
	editor selection: newSelection.