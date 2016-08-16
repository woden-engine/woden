time simulation
simulateTime: delta onElement: anElement
	| matrix  |
	angle := angle + (angularVelocity*(delta*angularSpeed)).
	matrix := (WMMatrix3F xyzRotation: angle) transposed.
	anElement orientation: matrix.
		
	anElement translateBy: (matrix transformVector3: (velocity*delta) + (acceleration*(delta*delta*0.5))).
	velocity := velocity + (acceleration*delta).