Class {
	#name : #WDCAbstractModel,
	#superclass : #Object,
	#category : #'WodenEngine-Core-Asset'
}

{ #category : #initialization }
WDCAbstractModel class >> loadFromFile: aFileName [
	^ WDCAbstractModelLoader loadFromFile: aFileName
]

{ #category : #'as yet unclassified' }
WDCAbstractModel >> openViewer [
	self subclassResponsibility
]
