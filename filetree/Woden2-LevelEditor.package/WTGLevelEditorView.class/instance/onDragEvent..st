event handling
onDragEvent: anEvent
	| dragPosition depth dragDelta |
	dragPosition := anEvent position.
	
	anEvent isLeftButtonDrag ifTrue: [
	].

	anEvent isRightButtonDrag ifTrue: [
		depth := self depthAtCameraDistance: 3.0.
		dragDelta := (self windowGlobalToWorld: dragPosition depth: depth) - (self windowGlobalToWorld: lastDragPosition depth: depth).
		cameraTransform translateBy: dragDelta asWMVector3D.
	].

	anEvent isCenterButtonDrag ifTrue: [
		dragDelta := anEvent delta.
		cameraAngle :=cameraAngle + (WMVector3D x: dragDelta y degreesToRadians y: dragDelta x degreesToRadians)
	].

	lastDragPosition := dragPosition.
	
