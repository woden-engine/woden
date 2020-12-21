Class {
	#name : #WDAESPlayerView,
	#superclass : #WDAESUniverseView,
	#instVars : [
		'playerEntity',
		'cameraComponent',
		'soundListener',
		'viewLivingTime',
		'soundGainFactor'
	],
	#category : #'WodenEngine-EntitySystem-Application'
}

{ #category : #accessing }
WDAESPlayerView >> attachCameraToPlayerEntity [
	cameraComponent ifNil: [ ^ self ].
	camera removeFromScene.
	playerEntity addComponent: cameraComponent.
]

{ #category : #rendering }
WDAESPlayerView >> buildUISceneGraphWith: builder [
	"Allow the game logic to draw an overlay."
	^ (model gameLogic buildUISceneGraphWith: builder) , (super buildUISceneGraphWith: builder)
]

{ #category : #accessing }
WDAESPlayerView >> camera [
	camera ifNil: [ self createCamera ].
	^ camera
]

{ #category : #'as yet unclassified' }
WDAESPlayerView >> close [
	soundListener ifNotNil: [ soundListener deactivate ].
	^ super close
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

{ #category : #'as yet unclassified' }
WDAESPlayerView >> ensureValidSoundListener [
	soundListener ifNil: [
		soundListener := self engine createSoundListener.
		soundListener gain: 0.0; activate
	].


]

{ #category : #'rendering process stages' }
WDAESPlayerView >> initialize [
	super initialize.
	soundGainFactor := 0.0.
	viewLivingTime := 0.0
]

{ #category : #opening }
WDAESPlayerView >> openedWithWindow: aWindow [
	super openedWithWindow: aWindow.
	self captureMouse
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
	cameraComponent ifNotNil: [
		cameraComponent applyActiveNearFarDistance.
		soundListener ifNotNil: [ cameraComponent applySoundListenerParameters: soundListener withGainFactor: soundGainFactor ]
	].
	super prepareRendering
]

{ #category : #'as yet unclassified' }
WDAESPlayerView >> spawnPlayer [
	self ensureValidSoundListener.
	self playerEntity: model gameLogic spawnPlayer
]

{ #category : #'rendering process stages' }
WDAESPlayerView >> updateForFrameDelta: delta [
	super updateForFrameDelta: delta.
	self isInVirtualReality ifTrue: [ 
		self updateVRForFrameDelta: delta
	].
	
]

{ #category : #'rendering process stages' }
WDAESPlayerView >> updateVRForFrameDelta: delta [
	playerEntity ifNotNil: [
		playerEntity sendInputEvent: #onVRCameraTransform: with: engine vrSystem hmdTrackedDevice currentPose deviceToAbsoluteTransform.
	].
]

{ #category : #visiting }
WDAESPlayerView >> visitJoyAxisEvent: anEvent [
	playerEntity ifNotNil: [ 
		playerEntity sendInputEvent: #onJoyAxis: with: anEvent.
	].
]

{ #category : #visiting }
WDAESPlayerView >> visitJoyButtonDownEvent: anEvent [
	playerEntity ifNotNil: [ 
		playerEntity sendInputEvent: #onJoyButtonDown: with: anEvent.
	].
]

{ #category : #visiting }
WDAESPlayerView >> visitJoyButtonUpEvent: anEvent [
	playerEntity ifNotNil: [ 
		playerEntity sendInputEvent: #onJoyButtonUp: with: anEvent.
	].
]

{ #category : #visiting }
WDAESPlayerView >> visitKeyDownEvent: anEvent [
	anEvent repeat > 0 ifTrue: [ ^ 0 ].
	anEvent modifiers alt  ifTrue: [ 
		anEvent symbol = OSK_F4 ifTrue: [ ^ self closeRequested ].
	].

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
