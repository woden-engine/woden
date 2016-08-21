as yet unclassified
toggleManipulationMode
	rotationMode := rotationMode not.
	editor selectionBoxViewsDo: #updateNodes.