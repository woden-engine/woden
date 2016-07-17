events
onDragEvent: event
	| dragDelta |
	dragDelta := event delta.
	view cameraAngle: view cameraAngle + (WMVector3D x: dragDelta y negated degreesToRadians y: dragDelta x degreesToRadians negated)