events
onDragEvent: event
	| dragDelta depth |
	depth := view depthAtCameraDistance: 3.0.
	totalDelta := totalDelta + event delta.
	dragDelta := (view windowGlobalToWorld: totalDelta depth: depth) - (view windowGlobalToWorld: 0@0 depth: depth).
	onNewTranslation value: dragDelta.