creating path
absoluteArcTo: endPoint angle: angle cw: cw
	| start end rotation center radius arcLength destVector arcSegments actualAngle |
	
	actualAngle := angle.
	start := lastPoint asWMComplexF.
	end := endPoint asWMComplexF.
	cw ifFalse: [ 
		actualAngle := angle negated.
	].

	rotation := WMComplexF angle: actualAngle.
	center := (end - (rotation *start)) / (1.0 asWMComplexF - rotation).

	radius := (end - center) length.
	(radius closeTo: 0.0) ifTrue: [ ^ self absoluteLineTo: endPoint. ].

	arcLength := radius * actualAngle abs.
	destVector := start - center.
	arcSegments := arcLength / arcSegmentLength min: maxArcSegments.
	arcSegments <= 0 ifTrue: [ ^ self absoluteLineTo: endPoint ].
	
	rotation := WMComplexF angle: actualAngle / arcSegments.
	1 to: arcSegments - 1 do: [ :i |
		self absoluteLineTo: (center + destVector) asWMVector2F.
		destVector := rotation * destVector.
	].

	self absoluteLineTo: endPoint.