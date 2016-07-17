as yet unclassified
onDragEvent: event
	| depth |
	depth := view depthAtCameraDistance: 3.0.
	endPoint := (view windowGlobalToWorld: event position depth: depth).
	self updateSelectionBox.