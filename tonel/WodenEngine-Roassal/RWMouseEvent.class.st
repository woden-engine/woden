Class {
	#name : #RWMouseEvent,
	#superclass : #RWEvent,
	#instVars : [
		'buttons',
		'position'
	],
	#category : 'WodenEngine-Roassal-Events'
}

{ #category : #accessing }
RWMouseEvent >> buttons [
	
	^ buttons
]

{ #category : #accessing }
RWMouseEvent >> buttons: anObject [
	
	buttons := anObject
]

{ #category : #testing }
RWMouseEvent >> isLeftButton [
	^ self buttons button1
]

{ #category : #testing }
RWMouseEvent >> isRightButton [
	^ self buttons button2
]

{ #category : #accessing }
RWMouseEvent >> position [
	
	^ position
]

{ #category : #accessing }
RWMouseEvent >> position: anObject [
	
	position := anObject
]
