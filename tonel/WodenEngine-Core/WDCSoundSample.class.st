Class {
	#name : #WDCSoundSample,
	#superclass : #WDCSoundDataSource,
	#instVars : [
		'data'
	],
	#category : 'WodenEngine-Core-Sound'
}

{ #category : #'as yet unclassified' }
WDCSoundSample >> buildHandle [
	handle := engine soundDevice createSampleFor: self.

]

{ #category : #accessing }
WDCSoundSample >> data [
	^ data
]

{ #category : #accessing }
WDCSoundSample >> data: anObject [
	data := anObject
]

{ #category : #'as yet unclassified' }
WDCSoundSample >> isSample [
	^ true
]
