Class {
	#name : #WDESSoundSourceComponent,
	#superclass : #WDESComponent,
	#instVars : [
		'soundSource',
		'dataSource',
		'position',
		'isGlobalSource',
		'looped',
		'playing',
		'gain',
		'pitch'
	],
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #notifications }
WDESSoundSourceComponent >> addedToScene: scene [
	self ensureValidSoundSource
]

{ #category : #accessing }
WDESSoundSourceComponent >> dataSource [
	^ dataSource
]

{ #category : #accessing }
WDESSoundSourceComponent >> dataSource: anObject [
	dataSource := anObject.
	soundSource ifNotNil: [ soundSource dataSource: dataSource ].
]

{ #category : #notifications }
WDESSoundSourceComponent >> ensureValidSoundSource [
	soundSource ifNotNil: [ ^ self ].

	soundSource := self engine createSoundSource.
	soundSource
		gain: gain;
		pitch: pitch;
		looped: looped;
		isGlobalSource: isGlobalSource.
	self updateSourcePosition.
	dataSource ifNotNil: [ 
		soundSource dataSource: dataSource.
		playing ifTrue: [ soundSource play ]
	]

]

{ #category : #accessing }
WDESSoundSourceComponent >> entityTransformChanged [
	self updateSourcePosition
]

{ #category : #accessing }
WDESSoundSourceComponent >> gain [
	^ gain
]

{ #category : #accessing }
WDESSoundSourceComponent >> gain: aNumber [
	gain := aNumber.
	soundSource ifNotNil: [ soundSource gain: gain ]
]

{ #category : #initialization }
WDESSoundSourceComponent >> initialize [
	super initialize.
	position := Float32x3 zeros.
	isGlobalSource := 0.0.
	looped := false.
	playing := false.
	gain := 1.0.
	pitch := 1.0.
]

{ #category : #accessing }
WDESSoundSourceComponent >> isGlobalSource [
	^ isGlobalSource
]

{ #category : #accessing }
WDESSoundSourceComponent >> isGlobalSource: aBoolean [
	isGlobalSource := aBoolean.
	soundSource ifNotNil: [ soundSource isGlobalSource: isGlobalSource ]
]

{ #category : #initialization }
WDESSoundSourceComponent >> loadSoundSample: sampleName [
	self dataSource: (self engine resourceCache loadSoundSample: sampleName)
]

{ #category : #accessing }
WDESSoundSourceComponent >> looped [
	^ looped
]

{ #category : #accessing }
WDESSoundSourceComponent >> looped: aBoolean [
	looped := aBoolean.
	soundSource ifNotNil: [ soundSource looped: looped ]
]

{ #category : #accessing }
WDESSoundSourceComponent >> pitch [
	^ pitch
]

{ #category : #accessing }
WDESSoundSourceComponent >> pitch: anObject [
	pitch := anObject.
	soundSource ifNotNil: [ soundSource pitch: pitch ]
]

{ #category : #accessing }
WDESSoundSourceComponent >> play [
	playing := true.
	soundSource ifNotNil: [ soundSource play ].

]

{ #category : #accessing }
WDESSoundSourceComponent >> position [
	^ position
]

{ #category : #accessing }
WDESSoundSourceComponent >> position: anObject [
	position := anObject.
	self updateSourcePosition
]

{ #category : #notifications }
WDESSoundSourceComponent >> precacheResources [
	self ensureValidSoundSource
]

{ #category : #accessing }
WDESSoundSourceComponent >> soundSource [
	^ soundSource
]

{ #category : #accessing }
WDESSoundSourceComponent >> stop [
	playing := false.
	soundSource ifNotNil: [ soundSource stop ].

]

{ #category : #accessing }
WDESSoundSourceComponent >> updateSourcePosition [
	(soundSource isNotNil and: [ownerEntity isNotNil]) ifTrue: [
		soundSource position: position + ownerEntity globalTransform translation
	]
]

{ #category : #notifications }
WDESSoundSourceComponent >> validSoundSource [
	self ensureValidSoundSource.
	^ soundSource
]
