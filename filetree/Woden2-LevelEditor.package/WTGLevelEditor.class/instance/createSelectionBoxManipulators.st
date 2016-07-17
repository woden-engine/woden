initialization
createSelectionBoxManipulators
	| node count |
	count := WMBox3DD unitCube manipulationCorners size.
	
	selectionBoxManipulatorNodes := (1 to: count) collect: [ :i |
		node := WTSSpatialObject new
			renderable: selectionBoxManipulatorMesh;
			visible: false;
			renderPriority: WTSNode renderPriorityEditorOpaqueAfter + 4;
			visible: false;
			yourself.
		scene add: node.
		node
	].
	selectionBoxManipulators := (1 to: count) collect: [ :i | WMBox3DD empty ].