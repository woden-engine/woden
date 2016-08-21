rendering
createTranslationAndRotationManipulators
	node transform setForBox: editor selectionBox box.
	self createManipulatorsAtPositions: editor selectionBox box rotationManipulationCorners center: editor selectionBox box center.
