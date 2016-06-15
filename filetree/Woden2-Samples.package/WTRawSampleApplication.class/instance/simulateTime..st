rendering
simulateTime: delta
	super simulateTime: delta.
	self simulateCamera: cameraObjectState time: delta.
