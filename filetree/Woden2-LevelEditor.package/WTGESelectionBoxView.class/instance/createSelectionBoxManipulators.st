initialization
createSelectionBoxManipulators
	| manipulatorNode corners |
	corners := WMBox3DD unitCube manipulationCorners.
	manipulatorNodesInstanceGroup := WTSSpatialObjectInstanceGroup new
		model: (WTGLevelEditorElementModel new view: view);
		useViewportCamera: true;
		depthSorted: true;
		renderable: manipulatorMesh;
		renderPriority: WTSNode renderPriorityEditorTranslucentAfter + 1;
		yourself.
		
	editor scene add: manipulatorNodesInstanceGroup.
	
	manipulatorNodes := corners collectWithIndex: [ :corner :index |				
		manipulatorNode := WTSLocalShapedSpatialObject new
			visible: false;
			renderPriority: WTSNode renderPriorityEditorTranslucentAfter + 1;
			yourself.
		manipulatorNode model: (WTGLevelEditorBoxManipulator new
				node: manipulatorNode;
				boxIndex: index;
				direction: corner normalized).

		manipulatorNodesInstanceGroup addChild: manipulatorNode.
		manipulatorNode
	].

	manipulatorBoxes := corners collect: [ :i | WMBox3DD empty ].