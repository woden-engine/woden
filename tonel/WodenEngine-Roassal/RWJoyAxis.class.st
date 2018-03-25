Class {
	#name : #RWJoyAxis,
	#superclass : #RWEvent,
	#instVars : [
		'which',
		'axis',
		'value'
	],
	#category : 'WodenEngine-Roassal-Events'
}

{ #category : #accessing }
RWJoyAxis >> axis [
	
	^ axis
]

{ #category : #accessing }
RWJoyAxis >> axis: anObject [
	
	axis := anObject
]

{ #category : #testing }
RWJoyAxis >> isLeftX [
	^ axis == 0
]

{ #category : #testing }
RWJoyAxis >> isLeftY [
	^ axis == 1
]

{ #category : #testing }
RWJoyAxis >> isRightX [
	^ axis == 2
]

{ #category : #testing }
RWJoyAxis >> isRightY [
	^ axis == 3
]

{ #category : #testing }
RWJoyAxis >> isTriggerLeft [
	^ axis == 4
]

{ #category : #testing }
RWJoyAxis >> isTriggerRight [
	^ axis == 5
]

{ #category : #accessing }
RWJoyAxis >> value [
	^ value
]

{ #category : #accessing }
RWJoyAxis >> value: anObject [
	
	value := anObject
]

{ #category : #accessing }
RWJoyAxis >> which [
	
	^ which
]

{ #category : #accessing }
RWJoyAxis >> which: anObject [
	
	which := anObject
]
