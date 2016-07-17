initialization
createSelectionBox
	selectionBox := WMBox3DD empty.
	selectionBoxNode := WTSSpatialObject new
		renderable: selectionBoxMesh;
		visible: false;
		renderPriority: WTSNode renderPriorityEditorOpaqueAfter + 3;
		yourself.
	scene add: selectionBoxNode.