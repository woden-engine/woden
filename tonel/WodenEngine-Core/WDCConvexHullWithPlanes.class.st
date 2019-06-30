Class {
	#name : #WDCConvexHullWithPlanes,
	#superclass : #Object,
	#instVars : [
		'planes'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #initialization }
WDCConvexHullWithPlanes >> initialize [
	super initialize.
	planes := #().
]

{ #category : #testing }
WDCConvexHullWithPlanes >> isBoxOutside: aBox [
	"Algorithm from: http://www.lighthouse3d.com/tutorials/view-frustum-culling/geometric-approach-testing-boxes-ii/"
	planes do: [ :plane |
		(plane isInFront: (aBox negativeVertex: plane normal)) ifTrue: [ ^ true ]
	].
	^ false
]

{ #category : #accessing }
WDCConvexHullWithPlanes >> planes [
	^ planes
]

{ #category : #accessing }
WDCConvexHullWithPlanes >> planes: anObject [
	planes := anObject
]
