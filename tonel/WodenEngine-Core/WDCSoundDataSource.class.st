Class {
	#name : #WDCSoundDataSource,
	#superclass : #WDCResourceWithSessionHandle,
	#instVars : [
		'sampleRate',
		'channels',
		'format'
	],
	#category : 'WodenEngine-Core-Sound'
}

{ #category : #accessing }
WDCSoundDataSource >> channels [
	^ channels
]

{ #category : #accessing }
WDCSoundDataSource >> channels: anObject [
	channels := anObject
]

{ #category : #accessing }
WDCSoundDataSource >> format [
	^ format
]

{ #category : #accessing }
WDCSoundDataSource >> format: anObject [
	format := anObject
]

{ #category : #initialization }
WDCSoundDataSource >> initialize [
	super initialize.
	sampleRate := 44100.
	channels := 1.
	format := #byte.
]

{ #category : #testing }
WDCSoundDataSource >> isSample [
	^ false
]

{ #category : #testing }
WDCSoundDataSource >> isSoundStream [
	^ false
]

{ #category : #accessing }
WDCSoundDataSource >> sampleRate [
	^ sampleRate
]

{ #category : #accessing }
WDCSoundDataSource >> sampleRate: anObject [
	sampleRate := anObject
]
