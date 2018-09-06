Class {
	#name : #WDAGSLevelPlayerView,
	#superclass : #WDASceneViewWithPompeii,
	#instVars : [
		'playerEntity',
		'lastFrameRateDrawing',
		'lastFrameRateCountFrame',
		'lastFrameDeltaTime',
		'playerEventHandler'
	],
	#category : #'WodenEngine-GameSystem-LevelPlayer'
}

{ #category : #'drawing 2d' }
WDAGSLevelPlayerView >> computeFrameDeltaTime [
	| currentTime |
	self flag: 'TODO: Use GPU timestamp query.'.
	lastFrameRateDrawing ifNil: [ lastFrameRateDrawing := Time microsecondClockValue ].
	lastFrameRateCountFrame ~~ engine frameBufferingDriver frameIndex ifTrue: [
		currentTime := Time microsecondClockValue.
		lastFrameDeltaTime := (currentTime - lastFrameRateDrawing) / 1000.0.
		lastFrameRateDrawing := currentTime.
		lastFrameRateCountFrame := engine frameBufferingDriver frameIndex
	].

	^ lastFrameDeltaTime



]

{ #category : #'drawing 2d' }
WDAGSLevelPlayerView >> drawFrameRateOn: canvas [
	| deltaTime builder mesh |
	deltaTime := self computeFrameDeltaTime.
	
	builder := canvas driver mesh2DBuilder.
	builder text
		color: Color green;
		font: self pompeiiDefaultFont;
			position: (0 @ self pompeiiDefaultFont getPreciseAscent);
			draw: ('CPU Frame Rate {1} ms / {2} FPS' format: {
				deltaTime printShowingDecimalPlaces: 3 .
				1000.0 / (deltaTime max: 0.01) printShowingDecimalPlaces: 3}).
	mesh := builder mesh.
	
	canvas draw: mesh.
]

{ #category : #'drawing 2d' }
WDAGSLevelPlayerView >> drawOnPompeiiCanvas: canvas [
	self drawFrameRateOn: canvas
]

{ #category : #events }
WDAGSLevelPlayerView >> handleEvent: anEvent [
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

{ #category : #opening }
WDAGSLevelPlayerView >> openedWithWindow: aWindow [
	playerEntity := model createPlayer.
	playerEntity
		addComponent: (WDGSViewComponent new view: self);
		spawn.
	self captureMouse
]

{ #category : #accessing }
WDAGSLevelPlayerView >> playerEventHandler [
	^ playerEventHandler
]

{ #category : #accessing }
WDAGSLevelPlayerView >> playerEventHandler: anObject [
	playerEventHandler := anObject
]

{ #category : #visiting }
WDAGSLevelPlayerView >> visitKeyDownEvent: anEvent [
	anEvent symbol = OSK_ESCAPE ifTrue: [ self releaseMouse . self close ].
	anEvent symbol = OSK_F1 ifTrue: [ self releaseMouse ].
	anEvent symbol = OSK_F2 ifTrue: [ self captureMouse ].
]
