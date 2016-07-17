accessing
editor: anObject
	editor := anObject.
	
	self
		createSelectionBoxManipulatorMesh;
		createSelectionBoxManipulators;
		createSelectionBoxMesh;
		createSelectionBox;
		updateColors