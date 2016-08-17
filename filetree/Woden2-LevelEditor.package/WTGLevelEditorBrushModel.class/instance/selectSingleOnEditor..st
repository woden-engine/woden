as yet unclassified
selectSingleOnEditor: editor
	| newSelection |
	newSelection := WTGLevelEditorSelectionBox new
		box: brush boundingBox;
		addElement: brush.
	editor selection: newSelection.