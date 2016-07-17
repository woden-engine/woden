events
onDragEvent: event
	| dragDelta depth |
	depth := view depthAtCameraDistance: 3.0.
	dragDelta := (view windowGlobalToWorld: event delta depth: depth) - (view windowGlobalToWorld: 0@0 depth: depth).
	view cameraTransform translateBy: dragDelta asWMVector3D.