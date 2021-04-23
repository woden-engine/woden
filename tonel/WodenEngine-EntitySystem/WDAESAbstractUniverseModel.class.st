Class {
	#name : #WDAESAbstractUniverseModel,
	#superclass : #WDASceneModel,
	#instVars : [
		'universe',
		'physicsWorld',
		'physicsWorldDebugDrawingSceneNode'
	],
	#category : #'WodenEngine-EntitySystem-Application'
}

{ #category : #accessing }
WDAESAbstractUniverseModel >> gameLogic [
	^ universe gameLogic
]

{ #category : #initialization }
WDAESAbstractUniverseModel >> initializeModel [
	self
		initializeScene;
		initializePhysicsWorld.
]

{ #category : #initialization }
WDAESAbstractUniverseModel >> initializePhysicsWorld [
]

{ #category : #initialization }
WDAESAbstractUniverseModel >> initializeScene [
	self newScene.
	universe ifNotNil: [ universe scene: scene ]
]

{ #category : #testing }
WDAESAbstractUniverseModel >> isAnimated [
	^ true
]

{ #category : #'instance creation' }
WDAESAbstractUniverseModel >> newScene [
	self scene: (WDSGScene for: engine).
	^ scene
]

{ #category : #'as yet unclassified' }
WDAESAbstractUniverseModel >> precacheResources [
	scene ifNotNil: [ scene precacheResources ].
	universe ifNotNil: [ universe precacheResources ].
]

{ #category : #'as yet unclassified' }
WDAESAbstractUniverseModel >> togglePhysicsDebugging [
	physicsWorldDebugDrawingSceneNode ifNotNil: [ physicsWorldDebugDrawingSceneNode toggleVisible ]
]

{ #category : #accessing }
WDAESAbstractUniverseModel >> universe [
	^ universe
]

{ #category : #accessing }
WDAESAbstractUniverseModel >> universe: anObject [
	universe ifNotNil: [
		universe
			scene: nil;
			physicsWorld: nil
	].
	universe := anObject.
	universe ifNotNil: [
		universe
			scene: scene;
			physicsWorld: physicsWorld
	].
]
