as yet unclassified
view: view selectSingleOnEditor: editor
	| newSelection |
	newSelection := WTGLevelEditorSelection new
		addElement: face.
	editor selection: newSelection.