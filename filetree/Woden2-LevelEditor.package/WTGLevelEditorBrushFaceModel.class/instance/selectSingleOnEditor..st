as yet unclassified
selectSingleOnEditor: editor
	| newSelection |
	newSelection := WTGLevelEditorSelection new
		addElement: face.
	editor selection: newSelection.