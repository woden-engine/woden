accessing
cornersDo: aBlock
	aBlock value: self nearBottomLeft.
	aBlock value: self nearBottomRight.
	aBlock value: self nearTopLeft.
	aBlock value: self nearTopRight.

	aBlock value: self farBottomLeft.
	aBlock value: self farBottomRight.
	aBlock value: self farTopLeft.
	aBlock value: self farTopRight.
