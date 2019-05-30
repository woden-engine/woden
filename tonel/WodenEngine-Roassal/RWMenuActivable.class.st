Class {
	#name : #RWMenuActivable,
	#superclass : #RWInteraction,
	#instVars : [
		'actions'
	],
	#category : #'WodenEngine-Roassal-Interaction'
}

{ #category : #public }
RWMenuActivable class >> action: anAction [

	^ self item: anAction asString action: anAction
]

{ #category : #public }
RWMenuActivable class >> item: title action: action [
	^ self new item: title action: action
]

{ #category : #visiting }
RWMenuActivable >> accept: aVisitor [
	^ aVisitor visitMenuActivableInteraction: self
]

{ #category : #public }
RWMenuActivable >> action: aSymbol [
	^ self item: aSymbol asString action: aSymbol
]

{ #category : #initialization }
RWMenuActivable >> initialize [ 
	super initialize.
	actions := OrderedCollection new.
	
]

{ #category : #hooks }
RWMenuActivable >> initializeElement: element [

	| menuActivable |
	(element hasInteraction: self class) ifFalse: [ ^ self initializeFirstTimeElement: element ].
	
	menuActivable := element getInteractionForClass: self class.
	actions do: [ :assoc |
		menuActivable item: assoc key action: assoc value ]
]

{ #category : #hooks }
RWMenuActivable >> initializeFirstTimeElement: element [
	element when: RWMouseRightButtonDown do: [ :event |
		TRUtil instance widgetFactory menuForAssociations: actions on: element
	]
]

{ #category : #public }
RWMenuActivable >> item: titleAsString action: aBlockOrSymbol [
	actions add: (titleAsString -> aBlockOrSymbol)
]
