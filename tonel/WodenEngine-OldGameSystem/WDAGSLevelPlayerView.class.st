Class {
	#name : #WDAGSLevelPlayerView,
	#superclass : #WDASceneViewWithPompeii,
	#instVars : [
		'playerEntity',
		'playerEventHandler'
	],
	#category : #'WodenEngine-OldGameSystem-LevelPlayer'
}

{ #category : #'drawing 2d' }
WDAGSLevelPlayerView >> drawFrameRateOn: canvas [
	| deltaTime builder mesh |
	deltaTime := engine frameBufferingDriver currentFrameCPUDeltaTime.
	
	builder := canvas driver mesh2DBuilder.
	builder text
		color: Color green;
		font: self babylonDefaultFont;
			position: (0 @ self babylonDefaultFont getPreciseAscent);
			draw: ('CPU Frame Rate {1} ms / {2} FPS' format: {
				(deltaTime*1000.0) printShowingDecimalPlaces: 3 .
				1.0 / (deltaTime max: 0.01) printShowingDecimalPlaces: 3.
				engine frameBufferingDriver lastFrameCPUConsumption * 1000.0 printShowingDecimalPlaces: 3});
			newline;
			draw: ('CPU Consumption {1} ms' format: {
				engine frameBufferingDriver lastFrameCPUConsumption * 1000.0 printShowingDecimalPlaces: 3}).
				
	mesh := builder mesh.
	
	canvas draw: mesh.
]

{ #category : #'drawing 2d' }
WDAGSLevelPlayerView >> drawOnBabylonCanvas: canvas [
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
	anEvent symbol = OSK_1 ifTrue: [ self model map togglePhysicsDebugging ].
]
