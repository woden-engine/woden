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
			convexHullPlanes addAll: each polytopeEnclosingPlanes 
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
			convexHullPoints addAll: each polytopeConvexHullVertices 
		].
	].
	^ convexHullPoints
]

{ #category : #serialization }
WDEPolyhedronConvexHullCollisionComponent >> encodeJsonKeyValues [
	^ super encodeJsonKeyValues , {
		#points . self convexHullPoints collect: [:each | each encodeForJSON ].
		#planes . self convexHullPlanes collect: [:each | each encodeForJSON ].
	}
]
