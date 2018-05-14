Class {
	#name : #WDPPompeiiDrawCommand,
	#superclass : #WDPPompeiiCommand,
	#instVars : [
		'mesh',
		'submesh'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Pompeii'
}

{ #category : #'as yet unclassified' }
WDPPompeiiDrawCommand >> executeWith: stateTracker on: surface [
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
WDPPompeiiDrawCommand >> mesh [
	^ mesh
]

{ #category : #accessing }
WDPPompeiiDrawCommand >> mesh: anObject [
	mesh := anObject
]

{ #category : #accessing }
WDPPompeiiDrawCommand >> submesh [
	^ submesh
]

{ #category : #accessing }
WDPPompeiiDrawCommand >> submesh: anObject [
	submesh := anObject
]
