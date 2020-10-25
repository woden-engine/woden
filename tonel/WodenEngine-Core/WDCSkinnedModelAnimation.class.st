Class {
	#name : #WDCSkinnedModelAnimation,
	#superclass : #Object,
	#instVars : [
		'name',
		'channels'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Asset'
}

{ #category : #accessing }
WDCSkinnedModelAnimation >> channels [
	^ channels
]

{ #category : #accessing }
WDCSkinnedModelAnimation >> channels: anObject [
	channels := anObject
]

{ #category : #accessing }
WDCSkinnedModelAnimation >> name [
	^ name
]

{ #category : #accessing }
WDCSkinnedModelAnimation >> name: anObject [
	name := anObject
]
