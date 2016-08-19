transformation building
setForBox: aBox
	self setIdentity;
		scaleBy: aBox extent;
		translateTo: aBox center asWMVector3D