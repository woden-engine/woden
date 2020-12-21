Class {
	#name : #WDAGSLevelPlayerView,
	#superclass : #WDASceneViewWith2DOverlay,
	#instVars : [
		'playerEntity',
		'playerEventHandler'
	],
	#category : #'WodenEngine-OldGameSystem-LevelPlayer'
}

{ #category : #'drawing 2d' }
WDAGSLevelPlayerView >> drawOnScaledBabylonCanvas: canvas [
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
