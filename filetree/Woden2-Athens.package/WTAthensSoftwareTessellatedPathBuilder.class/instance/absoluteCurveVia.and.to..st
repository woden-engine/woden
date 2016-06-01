creating path
absoluteCurveVia: cp1 and: cp2 to: aPoint
	| start control1 control2 end lineLength arcLength delta m1 m2 m3 m4 m5 m6 |
	start := lastPoint asWMVector2F.
	control1 := cp1 asWMVector2F. 
	control2 := cp2 asWMVector2F. 
	end := aPoint asWMVector2F.
	
   lineLength := (end - start) length.
	arcLength := (control1 - start) length + (control2 - control1) length + (end - control2) length.
	delta := arcLength - lineLength.
	
	(arcLength > (flattnessFactor * lineLength) and: [ delta > pixelThreshold ]) ifTrue: [ 
		m1 := (start + control1) * 0.5.
		m2 := (control1 + control2) * 0.5.
		m3 := (control2 + end) * 0.5.
		
		m4 := (m1 + m2) * 0.5.
		m5 := (m2 + m3) * 0.5.
		m6 := (m4 + m5) * 0.5.
		self
			absoluteCurveVia: m1 and: m4 to: m6;
			absoluteCurveVia: m2 and: m5 to: end
	] ifFalse: [
		self absoluteLineTo: end.
	]