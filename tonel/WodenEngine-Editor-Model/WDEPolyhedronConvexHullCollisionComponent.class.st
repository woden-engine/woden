Class {
	#name : #WDEPolyhedronConvexHullCollisionComponent,
	#superclass : #WDECollisionComponent3D,
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #visiting }
WDEPolyhedronConvexHullCollisionComponent >> accept: visitor [
	^ visitor visitPolyhedronConvexHullCollisionComponent: self
]

{ #category : #serialization }
WDEPolyhedronConvexHullCollisionComponent >> convexHullPlanes [
	| convexHullPlanes |
	self parent ifNil: [ ^ #() ].
	convexHullPlanes := OrderedCollection new.
	self parent components do: [ :each |
		each isVisualComponent ifTrue: [ 
			convexHullPlanes addAll: each polyhedronEnclosingPlanes 
		].
	].
	^ convexHullPlanes
]

{ #category : #serialization }
WDEPolyhedronConvexHullCollisionComponent >> convexHullPoints [
	| convexHullPoints |
	self parent ifNil: [ ^ #() ].
	convexHullPoints := OrderedCollection new.
	self parent components do: [ :each |
		each isVisualComponent ifTrue: [ 
			convexHullPoints addAll: each polyhedronConvexHullVertices 
		].
	].
	^ convexHullPoints
]

{ #category : #'as yet unclassified' }
WDEPolyhedronConvexHullCollisionComponent >> createCollisionShapeWithTransform: localTransform [
	| points |
	points := self convexHullPoints.
	localTransform isIdentity ifFalse: [ 
		points := points collect: [ :each | localTransform transformPosition: each ]
	].

	^ WDPhyConvexHullCollisionShape new
		points: ((StdnVector newFor: Float32x3) addAll: points; yourself);
		yourself
]

{ #category : #serialization }
WDEPolyhedronConvexHullCollisionComponent >> encodeJsonKeyValues [
	^ super encodeJsonKeyValues , {
		#points . self convexHullPoints collect: [:each | each encodeForJSON ].
		#planes . self convexHullPlanes collect: [:each | each encodeForJSON ].
	}
]

{ #category : #testing }
WDEPolyhedronConvexHullCollisionComponent >> isPolyhedronConvexHullCollisionComponent [
	^ true
]
