Class {
	#name : #WDPhyObject,
	#superclass : #Object,
	#instVars : [
		'handle',
		'physicsEngine'
	],
	#category : #'WodenEngine-Physics-Interface'
}

{ #category : #accessing }
WDPhyObject >> handle [
	^ handle
]

{ #category : #accessing }
WDPhyObject >> handle: anObject [
	handle := anObject
]

{ #category : #accessing }
WDPhyObject >> physicsEngine [
	^ physicsEngine
]

{ #category : #accessing }
WDPhyObject >> physicsEngine: anObject [
	physicsEngine := anObject
]
