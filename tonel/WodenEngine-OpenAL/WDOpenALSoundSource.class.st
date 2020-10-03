Class {
	#name : #WDOpenALSoundSource,
	#superclass : #Object,
	#instVars : [
		'device',
		'handle',
		'dataSource',
		'gain',
		'position',
		'velocity',
		'looped',
		'isGlobalSource',
		'pitch'
	],
	#pools : [
		'OpenALConstants'
	],
	#category : #'WodenEngine-OpenAL'
}

{ #category : #accessing }
WDOpenALSoundSource >> dataSource [
	^ dataSource
]

{ #category : #accessing }
WDOpenALSoundSource >> dataSource: anObject [
	dataSource := anObject.
	dataSource ifNotNil: [ dataSource applyOnSource: self ]
]

{ #category : #accessing }
WDOpenALSoundSource >> device [
	^ device
]

{ #category : #accessing }
WDOpenALSoundSource >> device: anObject [
	device := anObject
]

{ #category : #accessing }
WDOpenALSoundSource >> gain [
	^ gain
]

{ #category : #accessing }
WDOpenALSoundSource >> gain: anObject [
	gain := anObject.
	
	device asCurrentDo: [
		OpenAL sourcef: handle param: AL_GAIN value: gain.
	]
]

{ #category : #accessing }
WDOpenALSoundSource >> handle [
	^ handle
]

{ #category : #accessing }
WDOpenALSoundSource >> handle: anObject [
	handle := anObject
]

{ #category : #accessing }
WDOpenALSoundSource >> hasValidHandle [
	^ handle ~= 0
]

{ #category : #initialization }
WDOpenALSoundSource >> initialize [
	super initialize.
	gain := 1.0.
	pitch := 1.0.
	position := Float32x3 new.
	velocity := Float32x3 new.
	handle := 0.
	looped := false.
	isGlobalSource := false.
]

{ #category : #accessing }
WDOpenALSoundSource >> isGlobalSource [
	^ isGlobalSource
]

{ #category : #accessing }
WDOpenALSoundSource >> isGlobalSource: anObject [
	isGlobalSource := anObject.
	
	(self hasValidHandle) ifTrue: [
		device asCurrentDo: [
			OpenAL
				sourcei: handle param: AL_SOURCE_RELATIVE value: isGlobalSource asBit
		]
	]
]

{ #category : #accessing }
WDOpenALSoundSource >> looped [
	^ looped
]

{ #category : #accessing }
WDOpenALSoundSource >> looped: anObject [
	looped := anObject.
	
	(self hasValidHandle) ifTrue: [
		device asCurrentDo: [
			OpenAL
				sourcei: handle param: AL_LOOPING value: looped asBit
		]
	]
]

{ #category : #accessing }
WDOpenALSoundSource >> pitch [
	^ pitch
]

{ #category : #accessing }
WDOpenALSoundSource >> pitch: anObject [
	pitch := anObject.
	
	device asCurrentDo: [
		OpenAL sourcef: handle param: AL_PITCH value: pitch.
	]
]

{ #category : #'as yet unclassified' }
WDOpenALSoundSource >> play [
	device asCurrentDo: [
		OpenAL sourcePlay: handle.
	]
]

{ #category : #accessing }
WDOpenALSoundSource >> position [
	^ position
]

{ #category : #accessing }
WDOpenALSoundSource >> position: anObject [
	position := anObject.
	
	(self hasValidHandle) ifTrue: [
		device asCurrentDo: [
			OpenAL
				source3f: handle param: AL_POSITION value: position x value: position y value: position z.
		]
	]
]

{ #category : #'as yet unclassified' }
WDOpenALSoundSource >> sendValues [
	OpenAL
		sourcef: handle param: AL_GAIN value: gain;
		source3f: handle param: AL_POSITION value: position x value: position y value: position z;
		source3f: handle param: AL_VELOCITY value: velocity x value: velocity y value: velocity z.
]

{ #category : #'as yet unclassified' }
WDOpenALSoundSource >> stop [
	device asCurrentDo: [
		OpenAL sourceStop: handle.
	]
]

{ #category : #accessing }
WDOpenALSoundSource >> velocity [
	^ velocity
]

{ #category : #accessing }
WDOpenALSoundSource >> velocity: anObject [
	velocity := anObject.
	
	(self hasValidHandle) ifTrue: [
		device asCurrentDo: [
			OpenAL
				source3f: handle param: AL_VELOCITY value: position x value: position y value: position z.
		]
	]
]
