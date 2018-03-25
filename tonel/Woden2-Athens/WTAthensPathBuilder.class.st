Class {
	#name : #WTAthensPathBuilder,
	#superclass : #AthensPathBuilder,
	#instVars : [
		'absolute',
		'lastPoint'
	],
	#category : 'Woden2-Athens'
}

{ #category : #'path commands' }
WTAthensPathBuilder >> absolute [
	absolute := true
]

{ #category : #'path commands' }
WTAthensPathBuilder >> absoluteCCWArcTo: endPt angle: rot [
	self subclassResponsibility
]

{ #category : #'path commands' }
WTAthensPathBuilder >> absoluteCWArcTo: endPt angle: rot [
	self subclassResponsibility
]

{ #category : #'path commands' }
WTAthensPathBuilder >> absoluteCurveVia: cp1 and: cp2 to: aPoint [
	self subclassResponsibility
]

{ #category : #'path commands' }
WTAthensPathBuilder >> absoluteCurveVia: cp1 to: aPoint [
	self subclassResponsibility
]

{ #category : #'path commands' }
WTAthensPathBuilder >> absoluteLineTo: aPoint [
	self subclassResponsibility.
]

{ #category : #'path commands' }
WTAthensPathBuilder >> absoluteMoveTo: aPoint [
	self subclassResponsibility
]

{ #category : #'path commands' }
WTAthensPathBuilder >> ccwArcTo: endPt angle: rot [
	self absoluteCCWArcTo: (self toAbsolute: endPt) angle: rot

]

{ #category : #'creating path' }
WTAthensPathBuilder >> closePath [
	self close
]

{ #category : #'path commands' }
WTAthensPathBuilder >> curveVia: cp1 and: cp2 to: aPoint [
	self absoluteCurveVia: (self toAbsolute: cp1) and: (self toAbsolute: cp2) to: (self toAbsolute: aPoint).
]

{ #category : #'path commands' }
WTAthensPathBuilder >> curveVia: cp1 to: aPoint [
	self absoluteCurveVia: (self toAbsolute: cp1) to: (self toAbsolute: aPoint).
]

{ #category : #'path commands' }
WTAthensPathBuilder >> cwArcTo: endPt angle: rot [
	self absoluteCWArcTo: (self toAbsolute: endPt) angle: rot

]

{ #category : #initialization }
WTAthensPathBuilder >> initialize [
	super initialize.
	absolute := false.
	lastPoint := ZeroPoint.
]

{ #category : #'path commands' }
WTAthensPathBuilder >> lineTo: aPoint [
	self absoluteLineTo: (self toAbsolute: aPoint).
]

{ #category : #'path commands' }
WTAthensPathBuilder >> moveTo: aPoint [
	self absoluteMoveTo: (self toAbsolute: aPoint).
]

{ #category : #'path commands' }
WTAthensPathBuilder >> relative [
	absolute := false
]

{ #category : #private }
WTAthensPathBuilder >> toAbsolute: aPoint [
	^ absolute ifTrue: [aPoint] ifFalse: [ aPoint + lastPoint ]
]
