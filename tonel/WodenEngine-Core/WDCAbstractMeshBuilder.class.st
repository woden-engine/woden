Class {
	#name : #WDCAbstractMeshBuilder,
	#superclass : #Object,
	#instVars : [
		'engine'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #'instance creation' }
WDCAbstractMeshBuilder class >> for: anEngine [
	^ self new engine: anEngine
]
