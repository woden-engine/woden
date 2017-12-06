rendering process stages
updateForFrameDelta: delta
	super updateForFrameDelta: delta.
	currentTime := currentTime + delta