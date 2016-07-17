events
onDragEvent: event
	| dragDelta depth |
	depth := view depthAtCameraDistance: 3.0.
	dragDelta := (view windowGlobalToWorld: event delta depth: depth) - (view windowGlobalToWorld: 0@0 depth: depth).
	totalTranslation := totalTranslation + dragDelta.
	onNewTranslation value: totalTranslation.