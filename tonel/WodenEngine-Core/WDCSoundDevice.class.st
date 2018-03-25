Class {
	#name : #WDCSoundDevice,
	#superclass : #WDCResourceWithSessionHandle,
	#category : 'WodenEngine-Core-Sound'
}

{ #category : #'as yet unclassified' }
WDCSoundDevice >> createListener [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDCSoundDevice >> createSampleFor: sample [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDCSoundDevice >> createSource [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDCSoundDevice >> useListener: aSoundListener [
	self subclassResponsibility
]
