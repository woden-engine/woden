Class {
	#name : #WTAnimationAction,
	#superclass : #Object,
	#instVars : [
		'name',
		'bones'
	],
	#category : 'WodenEngine-Core-Mesh'
}

{ #category : #accessing }
WTAnimationAction >> bones [
	^ bones
]

{ #category : #accessing }
WTAnimationAction >> bones: anObject [
	bones := anObject
]

{ #category : #accessing }
WTAnimationAction >> name [
	^ name
]

{ #category : #accessing }
WTAnimationAction >> name: anObject [
	name := anObject
]

{ #category : #'as yet unclassified' }
WTAnimationAction >> numberOfFrames [
	^ bones first keyframes size
]
