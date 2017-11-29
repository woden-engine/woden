path commands
curveVia: cp1 and: cp2 to: aPoint
	self absoluteCurveVia: (self toAbsolute: cp1) and: (self toAbsolute: cp2) to: (self toAbsolute: aPoint).