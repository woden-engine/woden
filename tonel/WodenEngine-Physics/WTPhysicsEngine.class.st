Class {
	#name : #WTPhysicsEngine,
	#superclass : #Object,
	#classVars : [
		'CurrentEngine',
		'PhysicsSession'
	],
	#category : 'WodenEngine-Physics-Interface'
}

{ #category : #accessing }
WTPhysicsEngine class >> checkAndLoadEngine [
	(CurrentEngine == nil or: [ PhysicsSession ~~ Smalltalk session ]) ifTrue: [ 
		CurrentEngine := self pickEngine.
		PhysicsSession := Smalltalk session.
	].
]

{ #category : #accessing }
WTPhysicsEngine class >> current [
	self checkAndLoadEngine.
	CurrentEngine ifNil: [ self error: 'Not supported physics engine found.' ].
	^ CurrentEngine
]

{ #category : #testing }
WTPhysicsEngine class >> isAvailable [
	self checkAndLoadEngine.
	^ CurrentEngine ~~ nil.
]

{ #category : #testing }
WTPhysicsEngine class >> isSupported [
	^ false
]

{ #category : #initialisation }
WTPhysicsEngine class >> pickEngine [
	self allSubclasses do: [ :sc  | sc isSupported ifTrue: [ ^ sc new ] ].
	^ nil
]

{ #category : #factory }
WTPhysicsEngine >> createDynamicsWorld [
	self subclassResponsibility
]
