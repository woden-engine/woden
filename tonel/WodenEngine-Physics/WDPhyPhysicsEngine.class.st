Class {
	#name : #WDPhyPhysicsEngine,
	#superclass : #Object,
	#classVars : [
		'CurrentEngine',
		'PhysicsSession'
	],
	#category : #'WodenEngine-Physics-Interface'
}

{ #category : #accessing }
WDPhyPhysicsEngine class >> checkAndLoadEngine [
	(CurrentEngine == nil or: [ PhysicsSession ~~ Smalltalk session ]) ifTrue: [ 
		CurrentEngine := self pickEngine.
		PhysicsSession := Smalltalk session.
	].
]

{ #category : #accessing }
WDPhyPhysicsEngine class >> current [
	self checkAndLoadEngine.
	CurrentEngine ifNil: [ self error: 'Not supported physics engine found.' ].
	^ CurrentEngine
]

{ #category : #testing }
WDPhyPhysicsEngine class >> isAvailable [
	self checkAndLoadEngine.
	^ CurrentEngine ~~ nil.
]

{ #category : #testing }
WDPhyPhysicsEngine class >> isSupported [
	^ false
]

{ #category : #initialisation }
WDPhyPhysicsEngine class >> pickEngine [
	self allSubclasses do: [ :sc  | sc isSupported ifTrue: [ ^ sc new ] ].
	^ nil
]

{ #category : #factory }
WDPhyPhysicsEngine >> createDynamicsWorld [
	self subclassResponsibility
]
