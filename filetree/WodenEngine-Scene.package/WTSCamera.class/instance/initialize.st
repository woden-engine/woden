initialization
initialize
	super initialize.
	state := WTCameraState new.
	state projectionMatrix: WMMatrix4F identity