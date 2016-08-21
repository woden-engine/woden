map events
simulateTime: delta
	| spatialDesc orientation |
	linearVelocity := linearAcceleration * delta + linearVelocity.
	angularVelocity := angularAcceleration * delta + angularVelocity.
	
	angle := angle + (angularVelocity * delta).
	orientation := (WMMatrix3D yrot: angle y) * (WMMatrix3D xrot: angle x).

	spatialDesc := entity spatialDescription.
	spatialDesc transform
			orthonormal: orientation;
			translateBy: (orientation transformVector3: linearVelocity * delta).