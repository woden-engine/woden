Class {
	#name : #WDBBabylonDrawCommand,
	#superclass : #WDBBabylonCommand,
	#instVars : [
		'mesh',
		'submesh'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Babylon'
}

{ #category : #'as yet unclassified' }
WDBBabylonDrawCommand >> executeWith: stateTracker on: surface [
	| firstIndex |
	surface
		activateMaterial: submesh material;
		validateQuickState.
	firstIndex := (surface getMeshBaseIndex: mesh) + submesh startIndex.
	
	stateTracker
		primitiveType: submesh primitiveType;
		drawElements: submesh indexCount instance_count: 1 first_index: firstIndex base_vertex: (surface getMeshBaseVertex: mesh) base_instance: 0

]

{ #category : #accessing }
WDBBabylonDrawCommand >> mesh [
	^ mesh
]

{ #category : #accessing }
WDBBabylonDrawCommand >> mesh: anObject [
	mesh := anObject
]

{ #category : #accessing }
WDBBabylonDrawCommand >> submesh [
	^ submesh
]

{ #category : #accessing }
WDBBabylonDrawCommand >> submesh: anObject [
	submesh := anObject
]
