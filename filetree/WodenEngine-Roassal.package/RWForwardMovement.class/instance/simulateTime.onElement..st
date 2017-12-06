time simulation
simulateTime: delta onElement: anElement
	| orientation |
	angle := angle + (angularVelocity*(delta*angularSpeed)).
	orientation := (WMMatrix3F yrot: angle y) * (WMMatrix3F xrot: angle x).
	anElement
		orientation: orientation;
		translateBy: (orientation transformVector3: (velocity*(delta*speed))).
	velocity := velocity + (acceleration*delta).