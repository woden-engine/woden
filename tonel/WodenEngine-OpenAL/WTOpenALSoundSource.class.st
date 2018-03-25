Class {
	#name : #WTOpenALSoundSource,
	#superclass : #Object,
	#instVars : [
		'device',
		'handle',
		'dataSource',
		'gain',
		'position',
		'velocity'
	],
	#pools : [
		'OpenALConstants'
	],
	#category : 'WodenEngine-OpenAL'
}

{ #category : #accessing }
WTOpenALSoundSource >> dataSource [
	^ dataSource
]

{ #category : #accessing }
WTOpenALSoundSource >> dataSource: anObject [
	dataSource := anObject.
	dataSource ifNotNil: [ dataSource applyOnSource: self ]
]

{ #category : #accessing }
WTOpenALSoundSource >> device [
	^ device
]

{ #category : #accessing }
WTOpenALSoundSource >> device: anObject [
	device := anObject
]

{ #category : #accessing }
WTOpenALSoundSource >> gain [
	^ gain
]

{ #category : #accessing }
WTOpenALSoundSource >> gain: anObject [
	gain := anObject.
	
	device asCurrentDo: [
		OpenAL sourcef: handle param: AL_GAIN value: gain.
	]
]

{ #category : #accessing }
WTOpenALSoundSource >> handle [
	^ handle
]

{ #category : #accessing }
WTOpenALSoundSource >> handle: anObject [
	handle := anObject
]

{ #category : #accessing }
WTOpenALSoundSource >> hasValidHandle [
	^ handle ~= 0
]

{ #category : #initialization }
WTOpenALSoundSource >> initialize [
	super initialize.
	gain := 1.0.
	position := WMVector3F new.
	velocity := WMVector3F new.
	handle := 0.
]

{ #category : #'as yet unclassified' }
WTOpenALSoundSource >> play [
	device asCurrentDo: [
		OpenAL sourcePlay: handle.
	]
]

{ #category : #accessing }
WTOpenALSoundSource >> position [
	^ position
]

{ #category : #accessing }
WTOpenALSoundSource >> position: anObject [
	position := anObject.
	
	(self hasValidHandle) ifTrue: [
		device asCurrentDo: [
			OpenAL
				source3f: handle param: AL_POSITION value: position x value: position y value: position z.
		]
	]
]

{ #category : #'as yet unclassified' }
WTOpenALSoundSource >> sendValues [
	OpenAL
		sourcef: handle param: AL_GAIN value: gain;
		source3f: handle param: AL_POSITION value: position x value: position y value: position z;
		source3f: handle param: AL_VELOCITY value: velocity x value: velocity y value: velocity z.
]

{ #category : #'as yet unclassified' }
WTOpenALSoundSource >> stop [
	device asCurrentDo: [
		OpenAL sourceStop: handle.
	]
]

{ #category : #accessing }
WTOpenALSoundSource >> velocity [
	^ velocity
]

{ #category : #accessing }
WTOpenALSoundSource >> velocity: anObject [
	velocity := anObject.
	
	(self hasValidHandle) ifTrue: [
		device asCurrentDo: [
			OpenAL
				source3f: handle param: AL_VELOCITY value: position x value: position y value: position z.
		]
	]
]
