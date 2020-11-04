Class {
	#name : #WDCDynamicCompositeMeshRenderable,
	#superclass : #WDCMutableRenderable,
	#instVars : [
		'builder',
		'isValid',
		'concreteRenderable'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #'instance creation' }
WDCDynamicCompositeMeshRenderable class >> for: engine [
	^ self new initializeWithEngine: engine
]

{ #category : #accessing }
WDCDynamicCompositeMeshRenderable >> builder [
	^ builder
]

{ #category : #accessing }
WDCDynamicCompositeMeshRenderable >> builder: anObject [
	builder := anObject
]

{ #category : #'as yet unclassified' }
WDCDynamicCompositeMeshRenderable >> initialize [
	super initialize.
	isValid := false
]

{ #category : #initialization }
WDCDynamicCompositeMeshRenderable >> initializeWithEngine: anEngine [
	builder := WDCDynamicGenericMeshBuilder for: anEngine
]

{ #category : #'as yet unclassified' }
WDCDynamicCompositeMeshRenderable >> invalidate [
	isValid := false
]

{ #category : #copying }
WDCDynamicCompositeMeshRenderable >> postCopy [
	super postCopy.
	isValid := false.
	concreteRenderable := nil.
]

{ #category : #rendering }
WDCDynamicCompositeMeshRenderable >> renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [ 
	^ concreteRenderable renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex 
]

{ #category : #'as yet unclassified' }
WDCDynamicCompositeMeshRenderable >> validateForNode: aNode [
	isValid ifTrue: [ ^ self ].
	builder clear.
	
	aNode allChildrenDo: [ :child |
		child buildMeshOn: builder
	].
	
	concreteRenderable := builder mesh.
	self boundingBox: concreteRenderable boundingBox.
	isValid := true.
]
