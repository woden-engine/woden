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
WDCAbstractModel >> createViewer [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDCAbstractModel >> instanceMainSceneNodeFor: engine [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDCAbstractModel >> instanceSceneNodeNamed: sceneNodeName for: engine [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDCAbstractModel >> openViewer [
	^ self createViewer open
]
