Class {
	#name : #WDCPerFrameSimpleCommandList,
	#superclass : #Object,
	#instVars : [
		'engine',
		'perFrameLists'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Window'
}

{ #category : #'instance creation' }
WDCPerFrameSimpleCommandList class >> for: anEngine [
	^ self new engine: anEngine
]

{ #category : #accessing }
WDCPerFrameSimpleCommandList >> currentList [
	^ self perFrameLists at: (engine bufferingFrameIndexModule: self perFrameLists size) + 1
]

{ #category : #accessing }
WDCPerFrameSimpleCommandList >> engine [
	^ engine
]

{ #category : #accessing }
WDCPerFrameSimpleCommandList >> engine: anObject [
	engine := anObject
]

{ #category : #accessing }
WDCPerFrameSimpleCommandList >> perFrameLists [
	^ perFrameLists ifNil: [ perFrameLists := engine frameBufferingCollect: [ :i | WDCSimpleCommandList for: engine ] ]
]
