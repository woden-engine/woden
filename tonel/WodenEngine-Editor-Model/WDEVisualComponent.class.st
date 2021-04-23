Class {
	#name : #WDEVisualComponent,
	#superclass : #WDEEntityComponent,
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #'as yet unclassified' }
WDEVisualComponent class >> box: box [
	^ WDEBoxVisualComponent new
		box: box;
		yourself
]

{ #category : #'as yet unclassified' }
WDEVisualComponent class >> directionalLight [
	^ WDEDirectionalLightSourceVisualComponent new
]

{ #category : #testing }
WDEVisualComponent class >> isAbstract [
	^ self == WDEVisualComponent
]

{ #category : #'as yet unclassified' }
WDEVisualComponent class >> pointLight [
	^ WDEPointLightSourceVisualComponent new
]

{ #category : #'as yet unclassified' }
WDEVisualComponent class >> polyhedronBox: box [
	^ WDEPolyhedronVisualComponent new
		constructFacesForBox: box;
		yourself
]

{ #category : #'as yet unclassified' }
WDEVisualComponent class >> rectangle: rectangle [
	^ WDERectangleVisualComponent new
		rectangle: rectangle;
		yourself
]

{ #category : #'as yet unclassified' }
WDEVisualComponent class >> spotLight [
	^ WDESpotLightSourceVisualComponent new
]

{ #category : #accessing }
WDEVisualComponent >> boundingBox [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDEVisualComponent >> buildSolidMeshWith: meshBuilder levelEditorSession: levelEditorSession modelTransform: modelTransform [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDEVisualComponent >> buildWireMeshWith: meshBuilder material: renderMaterial [
	self subclassResponsibility
]

{ #category : #testing }
WDEVisualComponent >> isVisualComponent [
	^ true
]

{ #category : #'as yet unclassified' }
WDEVisualComponent >> planesForCollisionConvexHull [
	^ #()
]

{ #category : #'as yet unclassified' }
WDEVisualComponent >> pointsForCollisionConvexHull [
	^ #()
]
