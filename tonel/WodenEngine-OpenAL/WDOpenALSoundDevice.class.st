Class {
	#name : #WDOpenALSoundDevice,
	#superclass : #WDCSoundDevice,
	#instVars : [
		'device',
		'context',
		'currentListener'
	],
	#pools : [
		'OpenALConstants'
	],
	#category : #'WodenEngine-OpenAL'
}

{ #category : #'as yet unclassified' }
WDOpenALSoundDevice >> asCurrentDo: aBlock [
	context currentDuring: aBlock
]

{ #category : #accessing }
WDOpenALSoundDevice >> context [
	^ context
]

{ #category : #accessing }
WDOpenALSoundDevice >> context: anObject [
	context := anObject
]

{ #category : #'as yet unclassified' }
WDOpenALSoundDevice >> createListener [
	^ WDOpenALSoundListener new device: self.
]

{ #category : #factory }
WDOpenALSoundDevice >> createSampleFor: sample [
	| sid |
	self asCurrentDo: [
		sid := OpenAL genBuffer.
	].

	^ WDOpenALSoundSample new device: self; handle: sid; uploadSample: sample
]

{ #category : #factory }
WDOpenALSoundDevice >> createSource [
	| sid |
	self asCurrentDo: [
		sid := OpenAL genSource.
	].

	^ WDOpenALSoundSource new device: self; handle: sid
]

{ #category : #accessing }
WDOpenALSoundDevice >> currentListener [
	^ currentListener
]

{ #category : #accessing }
WDOpenALSoundDevice >> device [
	^ device
]

{ #category : #accessing }
WDOpenALSoundDevice >> device: anObject [
	device := anObject
]

{ #category : #'as yet unclassified' }
WDOpenALSoundDevice >> useListener: soundListener [
	currentListener := soundListener.
	currentListener
		ifNil: [ self asCurrentDo: [
				OpenAL listenerf: AL_GAIN value: 0.0
			]
		]
		ifNotNil: [ soundListener sendValues ]
]
