initialization
createSelectionBox
	node := WTSSpatialObject new
		renderable: boxMesh;
		visible: false;
		renderPriority: WTSNode renderPriorityEditorTranslucentAfter;
		yourself.
	editor scene add: node.