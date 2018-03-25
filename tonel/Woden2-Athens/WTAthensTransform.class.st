Class {
	#name : #WTAthensTransform,
	#superclass : #AthensTransform,
	#instVars : [
		'matrix'
	],
	#category : 'Woden2-Athens'
}

{ #category : #initialization }
WTAthensTransform >> initialize [
	super initialize.
	matrix := WMMatrix3F identity.
]

{ #category : #transformations }
WTAthensTransform >> loadAffineTransform: anAthenTransform [
	matrix
		m11: anAthenTransform sx asFloat; m12: anAthenTransform shx asFloat; m13: anAthenTransform x;
		m11: anAthenTransform shy asFloat; m12: anAthenTransform sy asFloat; m13: anAthenTransform y;
		m31: 0.0; m32: 0.0; m33: 0.0.
]

{ #category : #transformations }
WTAthensTransform >> loadIdentity [
	matrix := WMMatrix3F identity.
]

{ #category : #accessing }
WTAthensTransform >> matrix [
	^ matrix
]

{ #category : #accessing }
WTAthensTransform >> matrix: anObject [
	matrix := anObject
]

{ #category : #transformations }
WTAthensTransform >> multiplyBy: m [
	| wm |
	wm := WMMatrix3F 
		m11: m sx asFloat m12: m shx asFloat m13: m x asFloat
		m21: m shy asFloat m22: m sy asFloat m23: m y asFloat
		m31: 0.0 m32: 0.0 m33: 1.0.
	matrix := matrix * wm
]

{ #category : #transformations }
WTAthensTransform >> restoreAfter: aBlock [
	| oldMatrix |
	oldMatrix := matrix.
	aBlock ensure: [ matrix := oldMatrix. ]
]

{ #category : #transformations }
WTAthensTransform >> rotateByDegrees: angle [


	^ self rotateByRadians: angle degreesToRadians
]

{ #category : #transformations }
WTAthensTransform >> rotateByRadians: angle [
	matrix := matrix * (WMMatrix3F zrot: angle)
]

{ #category : #transformations }
WTAthensTransform >> scaleBy: factor [
	matrix := matrix * (factor isPoint
		ifTrue: [ WMMatrix3F scaleX: factor x asFloat y: factor y asFloat z: 1.0 ]
		ifFalse: [ WMMatrix3F scaleX: factor asFloat y: factor asFloat z: 1.0 ])
]

{ #category : #transformations }
WTAthensTransform >> scaleX: fx Y: fy [
	matrix := matrix * (WMMatrix3F scaleX: fx asFloat y: fy asFloat z: 1.0)
]

{ #category : #'vector-transform' }
WTAthensTransform >> transform: aPoint [ 
	^ ((matrix m11 * aPoint x) + (matrix m12 * aPoint y) + matrix m13) @
		((matrix m21 * aPoint x) + (matrix m22 * aPoint y) + matrix m23)
]

{ #category : #'vector-transform' }
WTAthensTransform >> transformPosition2: aWMVector2F [
	^ matrix transformPosition2: aWMVector2F
]

{ #category : #'vector-transform' }
WTAthensTransform >> transformX: px Y: py [ 
	^ self transform: px @ py
]

{ #category : #transformations }
WTAthensTransform >> translateBy: aPoint [
	self translateX: aPoint x Y: aPoint y
]

{ #category : #transformations }
WTAthensTransform >> translateX: px Y: py [
	matrix := matrix * (WMMatrix3F translate2DX: px asFloat y: py asFloat)
]
