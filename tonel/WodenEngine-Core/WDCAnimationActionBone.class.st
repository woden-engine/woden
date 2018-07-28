Class {
	#name : #WDCAnimationActionBone,
	#superclass : #Object,
	#instVars : [
		'boneIndex',
		'keyframes'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #accessing }
WDCAnimationActionBone >> boneIndex [
	^ boneIndex
]

{ #category : #accessing }
WDCAnimationActionBone >> boneIndex: anObject [
	boneIndex := anObject
]

{ #category : #accessing }
WDCAnimationActionBone >> keyframes [
	^ keyframes
]

{ #category : #accessing }
WDCAnimationActionBone >> keyframes: anObject [
	keyframes := anObject
]
