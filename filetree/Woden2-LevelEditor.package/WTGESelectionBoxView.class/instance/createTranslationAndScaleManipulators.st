rendering
createTranslationAndScaleManipulators
	node transform setForBox: editor selectionBox box.
	self createManipulatorsAtPositions: editor selectionBox box manipulationCorners center: editor selectionBox box center.
