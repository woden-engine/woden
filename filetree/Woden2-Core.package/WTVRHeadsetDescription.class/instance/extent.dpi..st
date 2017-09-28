accessing
extent: anExtent dpi: horizontalAndVerticalDPI
	extent := anExtent.
	dpi := horizontalAndVerticalDPI.
	physicalExtent := ((extent x / horizontalAndVerticalDPI x) * MetersPerInch) @ ((extent y / horizontalAndVerticalDPI y) * MetersPerInch).
	self invalidate