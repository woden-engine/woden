initialization
createSelectionBox
	node := WTSSpatialObject new
		model: (WTGLevelEditorElementModel new view: view);
		renderable: boxMesh;
		visible: false;
		renderPriority: WTSNode renderPriorityEditorTranslucentAfter;
		yourself.
	editor scene add: node.