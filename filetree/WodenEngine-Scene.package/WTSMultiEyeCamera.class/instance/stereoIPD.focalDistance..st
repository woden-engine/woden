projections
stereoIPD: newIPD focalDistance: newFocalDistance
	ipd := newIPD.
	focalDistance := newFocalDistance.
	projectionMode := #stereo.
	self applyIPDToEyes