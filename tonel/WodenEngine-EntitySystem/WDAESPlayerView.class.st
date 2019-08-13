Class {
	#name : #WDAESPlayerView,
	#superclass : #WDAESUniverseView,
	#instVars : [
		'playerEntity',
		'cameraComponent'
	],
	#category : #'WodenEngine-EntitySystem-Application'
}

{ #category : #accessing }
WDAESPlayerView >> attachCameraToPlayerEntity [
	cameraComponent ifNil: [ ^ self ].
	camera removeFromScene.
	playerEntity addComponent: cameraComponent.
]

{ #category : #accessing }
WDAESPlayerView >> camera [
	camera ifNil: [ self createCamera ].
	^ camera
]

{ #category : #accessing }
WDAESPlayerView >> createCamera [
	cameraComponent := WDESCameraSceneNodeComponent new.
	camera := cameraComponent validSceneNode.
	playerEntity
		ifNil: [ model scene add: camera ]
		ifNotNil: [ self attachCameraToPlayerEntity ].

]

{ #category : #accessing }
WDAESPlayerView >> detachCameraToPlayerEntity [
	cameraComponent ifNil: [ ^ self ].
	playerEntity removeComponent: cameraComponent.

]

{ #category : #rendering }
WDAESPlayerView >> drawOnBabylonCanvas: canvas [
	super drawOnBabylonCanvas: canvas.

	"Allow the game logic to draw an overlay."
	model gameLogic drawOnBabylonCanvas: canvas.
]

{ #category : #accessing }
WDAESPlayerView >> playerEntity [
	^ playerEntity
]

{ #category : #accessing }
WDAESPlayerView >> playerEntity: anObject [
	playerEntity ifNotNil: [ self detachCameraToPlayerEntity ].
	playerEntity := anObject.
	playerEntity ifNotNil: [ self attachCameraToPlayerEntity ].
]

{ #category : #'rendering process stages' }
WDAESPlayerView >> prepareRendering [
	cameraComponent ifNotNil: [ cameraComponent applyActiveNearFarDistance ].
	super prepareRendering
]

{ #category : #'as yet unclassified' }
WDAESPlayerView >> spawnPlayer [
	self playerEntity: model gameLogic spawnPlayer
]

{ #category : #visiting }
WDAESPlayerView >> visitKeyDownEvent: anEvent [
	anEvent symbol = OSK_1 ifTrue: [ self model togglePhysicsDebugging ].
	
	playerEntity ifNotNil: [ 
		playerEntity sendInputEvent: #onKeyDown: with: anEvent.
	].
]

{ #category : #visiting }
WDAESPlayerView >> visitKeyUpEvent: anEvent [
	playerEntity ifNotNil: [ 
		playerEntity sendInputEvent: #onKeyUp: with: anEvent.
	].
]

{ #category : #visiting }
WDAESPlayerView >> visitMouseButtonPressEvent: anEvent [
	playerEntity ifNotNil: [ 
		playerEntity sendInputEvent: #onMouseButtonDown: with: anEvent.
	].
]

{ #category : #visiting }
WDAESPlayerView >> visitMouseButtonReleaseEvent: anEvent [
	playerEntity ifNotNil: [ 
		playerEntity sendInputEvent: #onMouseButtonUp: with: anEvent.
	].
]

{ #category : #visiting }
WDAESPlayerView >> visitMouseMoveEvent: anEvent [
	playerEntity ifNotNil: [ 
		playerEntity sendInputEvent: #onMouseMotion: with: anEvent.
	].
]
