Class {
	#name : #WTOpenALSoundDevice,
	#superclass : #WDCSoundDevice,
	#instVars : [
		'device',
		'context',
		'currentListener'
	],
	#pools : [
		'OpenALConstants'
	],
	#category : 'WodenEngine-OpenAL'
}

{ #category : #'as yet unclassified' }
WTOpenALSoundDevice >> asCurrentDo: aBlock [
	context currentDuring: aBlock
]

{ #category : #accessing }
WTOpenALSoundDevice >> context [
	^ context
]

{ #category : #accessing }
WTOpenALSoundDevice >> context: anObject [
	context := anObject
]

{ #category : #'as yet unclassified' }
WTOpenALSoundDevice >> createListener [
	^ WTOpenALSoundListener new device: self.
]

{ #category : #factory }
WTOpenALSoundDevice >> createSampleFor: sample [
	| sid |
	self asCurrentDo: [
		sid := OpenAL genBuffer.
	].

	^ WTOpenALSoundSample new device: self; handle: sid; uploadSample: sample
]

{ #category : #factory }
WTOpenALSoundDevice >> createSource [
	| sid |
	self asCurrentDo: [
		sid := OpenAL genSource.
	].

	^ WTOpenALSoundSource new device: self; handle: sid
]

{ #category : #accessing }
WTOpenALSoundDevice >> currentListener [
	^ currentListener
]

{ #category : #accessing }
WTOpenALSoundDevice >> device [
	^ device
]

{ #category : #accessing }
WTOpenALSoundDevice >> device: anObject [
	device := anObject
]

{ #category : #'as yet unclassified' }
WTOpenALSoundDevice >> useListener: soundListener [
	currentListener := soundListener.
	currentListener ifNotNil: [ soundListener sendValues ]
]
