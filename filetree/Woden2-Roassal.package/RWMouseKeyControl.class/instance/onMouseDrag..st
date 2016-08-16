event handling
onMouseDrag: event
	| angleDelta |
	angleDelta := (WMVector3F x: event delta y y: event delta x z: 0.0) * self class angleDragScale.
	movement angle: movement angle + angleDelta.