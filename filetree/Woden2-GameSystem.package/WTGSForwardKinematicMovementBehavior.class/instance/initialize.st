initialization
initialize
	super initialize.
	angle := WMVector3D new.
	angularVelocity := WMVector3D new.
	angularAcceleration := WMVector3D new.
	linearVelocity := WMVector3D new.
	linearAcceleration := WMVector3D new.
	movingInGrounding := true.