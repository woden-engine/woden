rendering process stages
updateForDeltaMicroseconds: microsecondsDelta
	super updateForDeltaMicroseconds: microsecondsDelta.
	currentTime := currentTime + (microsecondsDelta * 1e-6)