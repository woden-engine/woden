Class {
	#name : #RWTRCanvas,
	#superclass : #Object,
	#instVars : [
		'customSurface',
		'engine'
	],
	#category : #'WodenEngine-Roassal-Trachel'
}

{ #category : #'instance creation' }
RWTRCanvas >> buildMorph [
	morph := self morphClass basicNew
		engine: engine;
		initialize;
		canvas: self;
		extent: self canvas extent.
	^ morph
]

{ #category : #initialization }
RWTRCanvas >> canvas [
	(session ~~ TRPlatform current session or: [ canvas isNil ]) ifTrue: [ 
		canvas := self createCanvasWithExtent: extent asIntegerPoint.
		session := TRPlatform current session
	].
	^ canvas
]

{ #category : #initialization }
RWTRCanvas >> createCanvasWithExtent: anExtent [
	customSurface ifNotNil: [ ^ customSurface ].
	engine ifNil: [ ^ nil ].
	^ WTAthensSurface engine: engine extent: anExtent
]

{ #category : #accessing }
RWTRCanvas >> customSurface [
	^ customSurface
]

{ #category : #accessing }
RWTRCanvas >> customSurface: anObject [
	customSurface := anObject.
	canvas := customSurface.
]

{ #category : #accessing }
RWTRCanvas >> engine [
	^ engine
]

{ #category : #accessing }
RWTRCanvas >> engine: anObject [
	engine := anObject.
	canvas := self createCanvasWithExtent: extent.
]

{ #category : #initialization }
RWTRCanvas >> initialize [
	super initialize.
	canvas := self createCanvasWithExtent: extent
]

{ #category : #'instance creation' }
RWTRCanvas >> morphClass [
	^ RWTRMorph
]
