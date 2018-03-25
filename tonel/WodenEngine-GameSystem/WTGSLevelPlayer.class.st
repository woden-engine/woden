Class {
	#name : #WTGSLevelPlayer,
	#superclass : #Object,
	#traits : 'TWTGSLevelPlayer',
	#classTraits : 'TWTGSLevelPlayer classTrait',
	#instVars : [
		'engine',
		'currentTime',
		'accumulatedUpdateTime',
		'map',
		'scene',
		'camera',
		'sceneRenderer',
		'athensSurfaces',
		'lastRenderTime',
		'playerEventHandler'
	],
	#pools : [
		'AGPUConstants',
		'OSKeySymbols'
	],
	#category : 'WodenEngine-GameSystem-LevelPlayer'
}

{ #category : #accessing }
WTGSLevelPlayer >> camera [
	^ camera
]

{ #category : #accessing }
WTGSLevelPlayer >> camera: aCamera [
	camera := aCamera
]

{ #category : #'as yet unclassified' }
WTGSLevelPlayer >> handleEvent: anEvent [
	super handleEvent: anEvent.
	playerEventHandler ifNotNil: [
		[
			playerEventHandler handleEvent: anEvent
		] on: Error do: [ :error |
			self releaseMouse.
			error freeze.
			[ error debug ] fork.
		]
	]
]

{ #category : #rendering }
WTGSLevelPlayer >> initializeApplication [
	super initializeApplication.
	scene := WTSScene for: engine.
	self initializeAthensSurfaces.
	self initializeSceneRenderer.
	self initializeCamera.
]

{ #category : #rendering }
WTGSLevelPlayer >> initializeAthensSurfaces [
	athensSurfaces := engine frameBufferingCollect: [ :i | WTAthensSurface engine: engine ].
]

{ #category : #initialization }
WTGSLevelPlayer >> initializeCamera [
	camera := WTSCamera new.
	scene add: camera.

]

{ #category : #rendering }
WTGSLevelPlayer >> initializeSceneRenderer [
	sceneRenderer := WTSForwardSceneRenderer for: engine.
	sceneRenderer scene: scene
]

{ #category : #accessing }
WTGSLevelPlayer >> map [
	^ map
]

{ #category : #accessing }
WTGSLevelPlayer >> map: anObject [
	map ifNotNil: [
		map scene: nil; levelPlayer: nil
	].

	map := anObject.
	
	map ifNotNil: [
		map scene: scene; levelPlayer: self
	]
	
]

{ #category : #accessing }
WTGSLevelPlayer >> playerEventHandler [
	^ playerEventHandler
]

{ #category : #accessing }
WTGSLevelPlayer >> playerEventHandler: anObject [
	playerEventHandler := anObject
]

{ #category : #rendering }
WTGSLevelPlayer >> renderFramesPerSecondOn: surface canvas: canvas [
	| font newRenderTime renderTime fps |
	newRenderTime := DateAndTime millisecondClockValue * 0.001.
	lastRenderTime ifNil: [ lastRenderTime := newRenderTime ].
	renderTime := newRenderTime - lastRenderTime.
	lastRenderTime := newRenderTime.
	(renderTime closeTo: 0.0) ifTrue: [ fps := 0.0 ] ifFalse: [ fps := 1.0 / renderTime ].
	font := engine fontCache default normal pointSize: 14.
	
	canvas setFont: font.
	canvas setPaint: (Color r: 0.0 g: 0.4 b: 0.0).
		
	canvas pathTransform restoreAfter: [
		canvas pathTransform translateX: 10 Y: (font getPreciseAscent).
		canvas drawString: (fps printShowingDecimalPlaces: 3) , ' FPS'.
	]
]

{ #category : #rendering }
WTGSLevelPlayer >> renderOnAthens: surface [
	surface drawDuring: [:canvas |
		self renderFramesPerSecondOn: surface canvas: canvas
	]
]

{ #category : #rendering }
WTGSLevelPlayer >> renderOnWindow: aWindow [
	| frameIndex framebuffer extent surface |
	frameIndex := engine newFrame.
	self updateCameraProjectionFor: aWindow.
	sceneRenderer
		currentTime: currentTime + accumulatedUpdateTime;
		renderFrame: frameIndex camera: camera on: aWindow.
	
	framebuffer := aWindow currentFramebuffer.
	extent := aWindow screenExtent.
	surface := athensSurfaces at: frameIndex.
	surface framebuffer: framebuffer extent: extent.
	self renderOnAthens: surface.
]

{ #category : #'as yet unclassified' }
WTGSLevelPlayer >> simulateTime: delta [
	super simulateTime: delta.
	map ifNotNil: [
		[
			map simulateTime: delta
		] on: Error do: [ :error |
			self releaseMouse.
			error freeze.
			[ error debug ] fork.
		]
	].
]

{ #category : #'map events' }
WTGSLevelPlayer >> spawn [
	self map spawn
]

{ #category : #'as yet unclassified' }
WTGSLevelPlayer >> spawnPlayerAtPosition: aPosition [
	map spawnEntityWithBehavior: WTGSPlayerBehavior new position: aPosition.
]

{ #category : #rendering }
WTGSLevelPlayer >> updateCameraProjectionFor: aWindow [
	| aspect h w projectionMatrix |
	aspect := aWindow screenWidth asFloat / aWindow screenHeight asFloat.
	h := 2.0.
	w := h * aspect.
	projectionMatrix := WMMatrix4F reverseDepthPerspectiveFovY: 60.0 aspect: aspect near: 0.01 far: 1000.0 invertedY: engine projectionInvertedY.
	camera state 
		projectionMatrix: projectionMatrix.
]

{ #category : #'as yet unclassified' }
WTGSLevelPlayer >> visitKeyDownEvent: anEvent [
	anEvent symbol = OSK_ESCAPE ifTrue: [ self releaseMouse . self close ].
	anEvent symbol = OSK_F1 ifTrue: [ self releaseMouse ].
	anEvent symbol = OSK_F2 ifTrue: [ self captureMouse ].
]

{ #category : #'as yet unclassified' }
WTGSLevelPlayer >> windowOpened: aWindow [
	aWindow captureMouse
]
