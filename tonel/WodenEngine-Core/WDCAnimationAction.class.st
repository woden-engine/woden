Class {
	#name : #WDCAnimationAction,
	#superclass : #Object,
	#instVars : [
		'name',
		'bones'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #accessing }
WDCAnimationAction >> bones [
	^ bones
]

{ #category : #accessing }
WDCAnimationAction >> bones: anObject [
	bones := anObject
]

{ #category : #accessing }
WDCAnimationAction >> name [
	^ name
]

{ #category : #accessing }
WDCAnimationAction >> name: anObject [
	name := anObject
]

{ #category : #'as yet unclassified' }
WDCAnimationAction >> numberOfFrames [
	^ bones first keyframes size
]
