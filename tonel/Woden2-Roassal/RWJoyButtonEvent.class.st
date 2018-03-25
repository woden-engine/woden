Class {
	#name : #RWJoyButtonEvent,
	#superclass : #RWEvent,
	#instVars : [
		'which',
		'button'
	],
	#category : 'Woden2-Roassal-Events'
}

{ #category : #accessing }
RWJoyButtonEvent >> button [
	
	^ button
]

{ #category : #accessing }
RWJoyButtonEvent >> button: anObject [
	
	button := anObject
]

{ #category : #testing }
RWJoyButtonEvent >> isButtonA [
	^ button == 0
]

{ #category : #testing }
RWJoyButtonEvent >> isButtonB [
	^ button == 1
]

{ #category : #testing }
RWJoyButtonEvent >> isButtonBack [
	^ button == 4
]

{ #category : #testing }
RWJoyButtonEvent >> isButtonGuide [
	^ button == 5
]

{ #category : #testing }
RWJoyButtonEvent >> isButtonStart [
	^ button == 6
]

{ #category : #testing }
RWJoyButtonEvent >> isButtonX [
	^ button == 2
]

{ #category : #testing }
RWJoyButtonEvent >> isButtonY [
	^ button == 3
]

{ #category : #testing }
RWJoyButtonEvent >> isDigitalPadDown [
	^ button == 12
]

{ #category : #testing }
RWJoyButtonEvent >> isDigitalPadLeft [
	^ button == 13
]

{ #category : #testing }
RWJoyButtonEvent >> isDigitalPadRight [
	^ button == 14
]

{ #category : #testing }
RWJoyButtonEvent >> isDigitalPadUp [
	^ button == 11
]

{ #category : #testing }
RWJoyButtonEvent >> isLeftShoulder [
	^ button == 9
]

{ #category : #testing }
RWJoyButtonEvent >> isLeftStick [
	^ button == 7
]

{ #category : #testing }
RWJoyButtonEvent >> isRightShoulder [
	^ button == 10
]

{ #category : #testing }
RWJoyButtonEvent >> isRightStick [
	^ button == 8
]

{ #category : #accessing }
RWJoyButtonEvent >> which [
	
	^ which
]

{ #category : #accessing }
RWJoyButtonEvent >> which: anObject [
	
	which := anObject
]
