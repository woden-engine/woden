creating path
absoluteCurveVia: cp1 to: aPoint
	| start middle end lineLength arcLength delta m1 m2 m3 |
	start := lastPoint asWMVector2F.
	middle := cp1 asWMVector2F. 
	end := aPoint asWMVector2F.
	
   lineLength := (end - start) length.
	arcLength := (middle - start) length + (end - middle) length.
	delta := arcLength - lineLength.
	
	(arcLength > (flattnessFactor * lineLength) and: [ delta > pixelThreshold ]) ifTrue: [ 
		m1 := (start + middle) * 0.5.
		m2 := (middle + end) * 0.5.
		m3 := (m1 + m2) * 0.5.
		self
			absoluteCurveVia: m1 to: m3;
			absoluteCurveVia: m2 to: end
	] ifFalse: [
		self absoluteLineTo: end.
	]