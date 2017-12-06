event handling
onMouseDrag: event
	| angleDelta |
	angleDelta := (WMVector3F x: event delta y negated y: event delta x negated z: 0.0) * self class angleDragScale.
	movement angle: movement angle + angleDelta.