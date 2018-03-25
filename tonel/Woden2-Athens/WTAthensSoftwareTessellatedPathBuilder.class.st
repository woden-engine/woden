Class {
	#name : #WTAthensSoftwareTessellatedPathBuilder,
	#superclass : #WTAthensPathBuilder,
	#instVars : [
		'backend',
		'baseIndex',
		'closed',
		'flattnessFactor',
		'pixelThreshold',
		'transformation',
		'arcSegmentLength',
		'maxArcSegments'
	],
	#category : 'Woden2-Athens'
}

{ #category : #defaults }
WTAthensSoftwareTessellatedPathBuilder class >> defaultArcSegmentLength [
	^ 3
]

{ #category : #defaults }
WTAthensSoftwareTessellatedPathBuilder class >> defaultFlattnessFactor [
	^ 1.001
]

{ #category : #defaults }
WTAthensSoftwareTessellatedPathBuilder class >> defaultMaxArcSegments [
	^ 16
]

{ #category : #defaults }
WTAthensSoftwareTessellatedPathBuilder class >> defaultPixelThreshold [
	^ 0.2
]

{ #category : #'creating path' }
WTAthensSoftwareTessellatedPathBuilder >> absoluteArcTo: endPoint angle: angle cw: cw [
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
]

{ #category : #'creating path' }
WTAthensSoftwareTessellatedPathBuilder >> absoluteCCWArcTo: endPoint angle: angle [
	^ self absoluteArcTo: endPoint angle: angle cw: false
]

{ #category : #'creating path' }
WTAthensSoftwareTessellatedPathBuilder >> absoluteCWArcTo: endPoint angle: angle [
	^ self absoluteArcTo: endPoint angle: angle cw: true
]

{ #category : #'creating path' }
WTAthensSoftwareTessellatedPathBuilder >> absoluteCurveVia: cp1 and: cp2 to: aPoint [
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
			absoluteCurveVia: m5 and: m3 to: end
	] ifFalse: [
		self absoluteLineTo: end.
	]
]

{ #category : #'creating path' }
WTAthensSoftwareTessellatedPathBuilder >> absoluteCurveVia: cp1 to: aPoint [
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
]

{ #category : #'path commands' }
WTAthensSoftwareTessellatedPathBuilder >> absoluteLineTo: aPoint [
	closed ifTrue: [
		backend
			subpathStarted;
			addVertex: lastPoint.
		closed := false.
	].

	backend
		addVertex: aPoint.
	lastPoint := aPoint.
]

{ #category : #'creating path' }
WTAthensSoftwareTessellatedPathBuilder >> absoluteMoveTo: aPoint [
	closed := true.
	subpathStart := aPoint.
	lastPoint := aPoint.
]

{ #category : #accessing }
WTAthensSoftwareTessellatedPathBuilder >> backend [
	^ backend
]

{ #category : #accessing }
WTAthensSoftwareTessellatedPathBuilder >> backend: anObject [
	^ backend := anObject
]

{ #category : #'path commands' }
WTAthensSoftwareTessellatedPathBuilder >> close [
	closed ifTrue: [ ^ self ].
	backend subpathClosed.
	closed := false.

]

{ #category : #'creating path' }
WTAthensSoftwareTessellatedPathBuilder >> createPath: aBlock [
	baseIndex := 0.
	closed := true.
	backend ifNil: [ backend := WTAthensMeshPathBuilderBackend new. ].
	aBlock value: self.
	^ backend.
]

{ #category : #initialization }
WTAthensSoftwareTessellatedPathBuilder >> initialize [
	super initialize.
	flattnessFactor := self class defaultFlattnessFactor.
	pixelThreshold := self class defaultPixelThreshold.
	arcSegmentLength := self class defaultArcSegmentLength.
	maxArcSegments := self class defaultMaxArcSegments.
	transformation := WMMatrix3F identity.
]

{ #category : #'path commands' }
WTAthensSoftwareTessellatedPathBuilder >> reset [
	closed := true.
	backend reset.
]

{ #category : #private }
WTAthensSoftwareTessellatedPathBuilder >> toAbsolute: aPoint [
	^ transformation transformPosition2: (absolute ifTrue: [aPoint asWMVector2F ] ifFalse: [aPoint asWMVector2F + lastPoint asWMVector2F])
]

{ #category : #accessing }
WTAthensSoftwareTessellatedPathBuilder >> transformation [
	^ transformation
]

{ #category : #accessing }
WTAthensSoftwareTessellatedPathBuilder >> transformation: anObject [
	transformation := anObject
]
