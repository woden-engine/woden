Class {
	#name : #WDCDynamicCompositeMeshRenderable,
	#superclass : #WDCRenderable,
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

{ #category : #'extra per object rendering data' }
WDCDynamicCompositeMeshRenderable >> createSceneDependentDataFor: engine into: bindings [
	^ nil
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

{ #category : #rendering }
WDCDynamicCompositeMeshRenderable >> renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [ 
	^ concreteRenderable renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex 
]

{ #category : #'as yet unclassified' }
WDCDynamicCompositeMeshRenderable >> renderOn: listBuilder mode: renderMode submode: submode instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [
	concreteRenderable renderOn: listBuilder mode: renderMode submode: submode instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex
]

{ #category : #'as yet unclassified' }
WDCDynamicCompositeMeshRenderable >> validateForNode: aNode [
	isValid ifTrue: [ ^ self ].
	builder clear.
	
	aNode children do: [ :child |
		child buildMeshOn: builder
	].
	
	concreteRenderable := builder mesh.
]
