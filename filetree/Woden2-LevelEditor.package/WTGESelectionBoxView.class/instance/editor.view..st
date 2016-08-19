accessing
editor: anObject view: aView
	editor := anObject.
	view := aView.
	
	self
		createSelectionBoxManipulatorMesh;
		createSelectionBoxManipulators;
		createSelectionBoxMesh;
		createSelectionBox;
		updateColors