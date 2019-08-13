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
	"Allow the game logic to draw an overlay."
	model gameLogic drawOnBabylonCanvas: canvas.
	
	super drawOnBabylonCanvas: canvas.

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
	anEvent repeat > 0 ifTrue: [ ^ 0 ].
	anEvent symbol = OSK_F1 ifTrue: [ self toggleMouseCapture ].
	anEvent symbol = OSK_F2 ifTrue: [ self model togglePhysicsDebugging ].
	anEvent symbol = OSK_F3 ifTrue: [ sceneRenderer debugNextRenderTarget ].
	anEvent symbol = OSK_F4 ifTrue: [ sceneRenderer debugRenderNextShadowMapViewport ].

	anEvent symbol = OSK_F11 ifTrue: [ self toggleFullscreen ].
	
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
