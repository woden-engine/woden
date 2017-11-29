event handling
onMouseMove: event
	| angleScale |
	angleScale := Float pi / 180.0 * 0.1.
	angle := angle + (WMVector3D x: event delta y * angleScale negated y: event delta x * angleScale  negated z: 0.0)