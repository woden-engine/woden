as yet unclassified
selectSingleOnEditor: editor
	| selectionBox |
	selectionBox := WTGLevelEditorSelectionBox new
		box: brush boundingBox;
		addElement: brush.
	editor selectionBox: selectionBox.