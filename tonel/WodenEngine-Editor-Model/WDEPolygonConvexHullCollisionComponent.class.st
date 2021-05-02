Class {
	#name : #WDEPolygonConvexHullCollisionComponent,
	#superclass : #WDECollisionComponent2D,
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #visiting }
WDEPolygonConvexHullCollisionComponent >> accept: visitor [
	^ visitor visitPolygonConvexHullCollisionComponent: self
]

{ #category : #accessing }
WDEPolygonConvexHullCollisionComponent >> boundingRectangle [
	^ RectangleF32 encompassing: self convexHullPoints
]

{ #category : #'as yet unclassified' }
WDEPolygonConvexHullCollisionComponent >> convexHull3DPoints [
	| points halfThickness |
	points := self convexHullPoints.
	halfThickness := self sectorLayer layerHalfThickness.
	^ (points collect: [ :each  | Float32x3 xy: each z: halfThickness negated ]) ,
		(points collect: [ :each  | Float32x3 xy: each z: halfThickness ])
]

{ #category : #serialization }
WDEPolygonConvexHullCollisionComponent >> convexHullPoints [
	| convexHullPoints |
	self parent ifNil: [ ^ #() ].
	convexHullPoints := OrderedCollection new.
	self parent components do: [ :each |
		each isVisualComponent ifTrue: [ 
			convexHullPoints addAll: each polygonConvexHullVertices 
		].
	].
	^ convexHullPoints
]

{ #category : #'as yet unclassified' }
WDEPolygonConvexHullCollisionComponent >> createCollisionShapeWithTransform: localTransform [
	| points |
	points := self convexHull3DPoints.
	localTransform isIdentity ifFalse: [ 
		points := points collect: [ :each | localTransform transformPosition: each ]
	].

	^ WDPhyConvexHullCollisionShape new
		points: ((StdnVector newFor: Float32x3) addAll: points; yourself);
		yourself
]

{ #category : #serialization }
WDEPolygonConvexHullCollisionComponent >> encodeJsonKeyValues [
	^ super encodeJsonKeyValues , {
		#points . self convexHullPoints collect: [:each | each encodeForJSON ].
	}
]

{ #category : #testing }
WDEPolygonConvexHullCollisionComponent >> isPolygonConvexHullCollisionComponent [
	^ true
]
