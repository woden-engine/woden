Class {
	#name : #WDCSkinnedModelBone,
	#superclass : #WDCSkinnedModelBoneState,
	#instVars : [
		'name',
		'index',
		'parentIndex'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Asset'
}

{ #category : #accessing }
WDCSkinnedModelBone >> index [
	^ index
]

{ #category : #accessing }
WDCSkinnedModelBone >> index: anObject [
	index := anObject
]

{ #category : #accessing }
WDCSkinnedModelBone >> name [
	^ name
]

{ #category : #accessing }
WDCSkinnedModelBone >> name: anObject [
	name := anObject
]

{ #category : #accessing }
WDCSkinnedModelBone >> parentIndex [
	^ parentIndex
]

{ #category : #accessing }
WDCSkinnedModelBone >> parentIndex: anObject [
	parentIndex := anObject
]
