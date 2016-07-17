initialization
createSelectionBoxManipulators
	| manipulatorNode corners |
	corners := WMBox3DD unitCube manipulationCorners.
	
	manipulatorNodes := corners collectWithIndex: [ :corner :index |				
		manipulatorNode := WTSSpatialObject new
			renderable: manipulatorMesh;
			visible: false;
			renderPriority: WTSNode renderPriorityEditorTranslucentAfter + 1;
			yourself.
		manipulatorNode model: (WTGLevelEditorBoxManipulator new
				node: manipulatorNode;
				boxIndex: index;
				direction: corner normalized).

		editor scene add: manipulatorNode.
		manipulatorNode
	].

	manipulatorBoxes := corners collect: [ :i | WMBox3DD empty ].