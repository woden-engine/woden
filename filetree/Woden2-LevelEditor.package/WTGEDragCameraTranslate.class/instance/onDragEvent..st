events
onDragEvent: event
	| dragDelta depth |
	depth := view depthAtCameraDistance: 3.0.
	dragDelta := (view windowGlobalToLocal: event delta depth: depth) - (view windowGlobalToLocal: 0@0 depth: depth).
	(event modifiers isCtrl or: [event modifiers isCmd]) ifTrue: [ 
		dragDelta := dragDelta asWMVector3D.
		dragDelta := WMVector3D x: dragDelta x y: 0.0 z: dragDelta y negated
	].

	view cameraTransform translateBy: (view cameraTransform transformVector3: dragDelta asWMVector3D).