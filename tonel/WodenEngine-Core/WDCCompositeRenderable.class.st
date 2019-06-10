Class {
	#name : #WDCCompositeRenderable,
	#superclass : #WDCRenderable,
	#instVars : [
		'renderables'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #'extra per object rendering data' }
WDCCompositeRenderable >> createSceneDependentDataFor: engine into: bindings [
]

{ #category : #'as yet unclassified' }
WDCCompositeRenderable >> engineChangedTo: newEngine [
	renderables do: [ :renderable |
		renderable engineChangedTo: newEngine
	]
]

{ #category : #rendering }
WDCCompositeRenderable >> renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [
	renderables do: [ :renderable |
		renderable renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex
	]
]

{ #category : #rendering }
WDCCompositeRenderable >> renderOn: listBuilder mode: renderMode submode: submode instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [
	renderables do: [ :renderable |
		renderable renderOn: listBuilder mode: renderMode submode: submode instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex
	]
]

{ #category : #accessing }
WDCCompositeRenderable >> renderables [
	^ renderables
]

{ #category : #accessing }
WDCCompositeRenderable >> renderables: anObject [
	renderables := anObject
]
