Class {
	#name : #WDCSimpleCommandList,
	#superclass : #Object,
	#instVars : [
		'engine',
		'commandAllocator',
		'commandList'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Window'
}

{ #category : #'instance creation' }
WDCSimpleCommandList class >> for: anEngine [
	^ self new engine: anEngine
]

{ #category : #accessing }
WDCSimpleCommandList >> commandAllocator [
	^ commandAllocator
]

{ #category : #accessing }
WDCSimpleCommandList >> commandAllocator: anObject [
	commandAllocator := anObject
]

{ #category : #accessing }
WDCSimpleCommandList >> commandList [
	^ commandList
]

{ #category : #accessing }
WDCSimpleCommandList >> commandList: anObject [
	commandList := anObject
]

{ #category : #accessing }
WDCSimpleCommandList >> engine [
	^ engine
]

{ #category : #accessing }
WDCSimpleCommandList >> engine: anObject [
	engine := anObject
]

{ #category : #'as yet unclassified' }
WDCSimpleCommandList >> validCommandAllocator [
	^ commandAllocator ifNil: [ commandAllocator := engine createGraphicsDirectCommandListAllocator ]
]

{ #category : #accessing }
WDCSimpleCommandList >> validCommandList [
	^ commandList ifNil: [ commandList := self validCommandAllocator createListNow ]
]
