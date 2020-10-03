Class {
	#name : #WDOpenALSoundSample,
	#superclass : #Object,
	#instVars : [
		'device',
		'handle'
	],
	#pools : [
		'OpenALConstants'
	],
	#category : #'WodenEngine-OpenAL'
}

{ #category : #'as yet unclassified' }
WDOpenALSoundSample >> applyOnSource: source [
	source hasValidHandle ifFalse: [ ^ self ].
	OpenAL sourcei: source handle param: AL_BUFFER value: handle.
]

{ #category : #accessing }
WDOpenALSoundSample >> device [
	^ device
]

{ #category : #accessing }
WDOpenALSoundSample >> device: anObject [
	device := anObject
]

{ #category : #accessing }
WDOpenALSoundSample >> handle [
	^ handle
]

{ #category : #accessing }
WDOpenALSoundSample >> handle: anObject [
	handle := anObject
]

{ #category : #'as yet unclassified' }
WDOpenALSoundSample >> mapFormat: format channels: channels [
	channels = 1 ifTrue: [ 
		format == #byte ifTrue: [ ^ AL_FORMAT_MONO8 ].
		format == #short ifTrue: [ ^ AL_FORMAT_MONO16 ].
	].
	channels = 2 ifTrue: [ 
		format == #byte ifTrue: [ ^ AL_FORMAT_STEREO8 ].
		format == #short ifTrue: [ ^ AL_FORMAT_STEREO16 ].
	].
	self error: 'Unsupported sound format.'.

]

{ #category : #'as yet unclassified' }
WDOpenALSoundSample >> uploadSample: sample [
	| data |
	sample data ifNil: [ ^ self ].
	data := sample data.
	
	device asCurrentDo: [
		OpenAL bufferData: handle format: (self mapFormat: sample format channels: sample channels) data: data size: data size freq: sample sampleRate
	]
]
