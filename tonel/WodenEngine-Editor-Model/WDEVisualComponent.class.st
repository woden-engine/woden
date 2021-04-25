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

{ #category : #rendering }
WDEVisualComponent >> buildSolidMeshWith: meshBuilder levelEditorSession: levelEditorSession modelTransform: modelTransform [
	self subclassResponsibility
]

{ #category : #rendering }
WDEVisualComponent >> buildWireMeshWith: meshBuilder material: renderMaterial [
	self subclassResponsibility
]

{ #category : #testing }
WDEVisualComponent >> canBeSubtracted [
	^ false
]

{ #category : #testing }
WDEVisualComponent >> hasIntersectionWith: otherVisualComponent withTransform: transform [
	^ otherVisualComponent hasIntersectionWithPolytopeVisualComponent: self withTransform: transform inverse
]

{ #category : #testing }
WDEVisualComponent >> hasIntersectionWithBoxVisualComponent: other withTransform: otherTransform [
	^ self hasIntersectionWithPolytopeVisualComponent: other withTransform: otherTransform
]

{ #category : #testing }
WDEVisualComponent >> hasIntersectionWithPolytopeVisualComponent: other withTransform: otherTransform [
	| mySupportFunction otherSupportFunction otherTransformedSupportFunction |
	mySupportFunction := self polytopeSupportFunction.
	mySupportFunction ifNil: [ ^ false ].

	otherSupportFunction := other polytopeSupportFunction.
	otherSupportFunction ifNil: [ ^ false ].
	
	otherTransformedSupportFunction := [ :direction | otherTransform transformPosition: (otherSupportFunction value: (otherTransform inverseTransformVector: direction)) ].

	^ GJK testIntersectionBetween: mySupportFunction and: otherTransformedSupportFunction
]

{ #category : #testing }
WDEVisualComponent >> isVisualComponent [
	^ true
]

{ #category : #representations }
WDEVisualComponent >> polytopeConvexHullVertices [
	^ #()
]

{ #category : #representations }
WDEVisualComponent >> polytopeEnclosingPlanes [
	^ #()
]

{ #category : #representations }
WDEVisualComponent >> polytopeSupportFunction [
	^ nil
]

{ #category : #operations }
WDEVisualComponent >> subtract: otherVisualComponent withTransform: transform [
	^ { self }
]
