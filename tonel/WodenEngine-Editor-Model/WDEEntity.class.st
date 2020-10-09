Class {
	#name : #WDEEntity,
	#superclass : #WDELevelElement,
	#instVars : [
		'sectorLayer',
		'className',
		'visualComponent',
		'collisionComponent'
	],
	#category : #'WodenEngine-Editor-Model'
}

{ #category : #accessing }
WDEEntity >> className [
	^ className
]

{ #category : #accessing }
WDEEntity >> className: anObject [
	className := anObject
]

{ #category : #accessing }
WDEEntity >> collisionComponent [
	^ collisionComponent
]

{ #category : #accessing }
WDEEntity >> collisionComponent: anObject [
	collisionComponent := anObject
]

{ #category : #initialization }
WDEEntity >> initialize [
	super initialize.
]

{ #category : #accessing }
WDEEntity >> sectorLayer [
	^ sectorLayer
]

{ #category : #accessing }
WDEEntity >> sectorLayer: anObject [
	sectorLayer := anObject
]

{ #category : #accessing }
WDEEntity >> visualComponent [
	^ visualComponent
]

{ #category : #accessing }
WDEEntity >> visualComponent: anObject [
	visualComponent := anObject
]
