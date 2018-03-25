Class {
	#name : #WTAnimationActionBone,
	#superclass : #Object,
	#instVars : [
		'boneIndex',
		'keyframes'
	],
	#category : 'WodenEngine-Core-Mesh'
}

{ #category : #accessing }
WTAnimationActionBone >> boneIndex [
	^ boneIndex
]

{ #category : #accessing }
WTAnimationActionBone >> boneIndex: anObject [
	boneIndex := anObject
]

{ #category : #accessing }
WTAnimationActionBone >> keyframes [
	^ keyframes
]

{ #category : #accessing }
WTAnimationActionBone >> keyframes: anObject [
	keyframes := anObject
]
