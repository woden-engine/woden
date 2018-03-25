Class {
	#name : #WTBlocApplication,
	#superclass : #WTAnimatedApplication,
	#instVars : [
		'blocUniverse',
		'athensSurfaces',
		'mainBlocSpace',
		'lastRenderTime'
	],
	#category : 'Woden2-Bloc'
}

{ #category : #rendering }
WTBlocApplication >> activateBlocSpace: aSpace [
	| universe |
	universe := BlUniverse default.
	universe
		start;
		addPulseListener: aSpace
]

{ #category : #rendering }
WTBlocApplication >> createMainBlocSpace [
	^ nil
]

{ #category : #'as yet unclassified' }
WTBlocApplication >> findEventHandlerFor: anEvent [
	mainBlocSpace ifNotNil: [ ^ mainBlocSpace hostWindow eventHandler ].
	^ self
]

{ #category : #'as yet unclassified' }
WTBlocApplication >> handleEvent: anEvent [
	| eventHandler |
	eventHandler := self findEventHandlerFor: anEvent.
	eventHandler ifNil: [ ^ self ].
	eventHandler == self
		ifTrue: [ ^ anEvent accept: self ]
		ifFalse: [ eventHandler handleEvent: anEvent. ]
	
]

{ #category : #rendering }
WTBlocApplication >> initializeApplication [
	super initializeApplication.
	athensSurfaces := engine frameBufferingCollect: [ :i | WTAthensSurface engine: engine ].
	mainBlocSpace := self createMainBlocSpace.
	mainBlocSpace ifNotNil: [ self activateBlocSpace: mainBlocSpace ].
]

{ #category : #accessing }
WTBlocApplication >> mainBlocSpace [
	^ mainBlocSpace
]

{ #category : #accessing }
WTBlocApplication >> mainBlocSpace: anObject [
	mainBlocSpace := anObject.
]

{ #category : #rendering }
WTBlocApplication >> renderAboveBlocOnAthens: surface canvas: canvas [
]

{ #category : #rendering }
WTBlocApplication >> renderContentOnWindow: aWindow frameIndex: frameIndex [
]

{ #category : #rendering }
WTBlocApplication >> renderOnAthens: surface [
	surface drawDuring: [:canvas |
		mainBlocSpace ifNil: [
			surface clear: Color red.
		] ifNotNil: [
			mainBlocSpace fullDrawOnAthensCanvas: canvas.
		].
		self renderAboveBlocOnAthens: surface canvas: canvas
	].


	
]

{ #category : #rendering }
WTBlocApplication >> renderOnWindow: aWindow [
	| frameIndex |
	frameIndex := engine newFrame.
	self renderContentOnWindow: aWindow frameIndex: frameIndex.
	self renderOverlaysOnWindow: aWindow frameIndex: frameIndex.
]

{ #category : #rendering }
WTBlocApplication >> renderOverlaysOnWindow: aWindow frameIndex: frameIndex [
	| surface framebuffer extent |
	framebuffer := aWindow currentFramebuffer.
	extent := aWindow screenExtent.
	surface := athensSurfaces at: frameIndex.
	surface framebuffer: framebuffer extent: extent.
	(mainBlocSpace isNotNil and: [ mainBlocSpace extent ~= extent ]) ifTrue: [
		mainBlocSpace extent: extent
	].
	self renderOnAthens: surface.
]
