rendering
simulateTime: delta
	super simulateTime: delta.
	self simulateCameraMovement: delta
