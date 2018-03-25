Class {
	#name : #WDCCommandListAllocator,
	#superclass : #WDCResourceWithSessionHandle,
	#instVars : [
		'listType',
		'queue',
		'queueType'
	],
	#category : 'WodenEngine-Core-GPU-Resources'
}

{ #category : #'resource building' }
WDCCommandListAllocator >> buildHandle [
	queue := self findCommandQueue.
	handle := engine device createCommandAllocator: AGPU_COMMAND_LIST_TYPE_DIRECT queue: queue.
	self assert: handle isNull not.
]

{ #category : #'command list type setting' }
WDCCommandListAllocator >> bundle [
	self listType: AGPU_COMMAND_LIST_TYPE_BUNDLE
]

{ #category : #construction }
WDCCommandListAllocator >> createList [
	^ (WDCCommandList for: engine) allocator: self
]

{ #category : #construction }
WDCCommandListAllocator >> createListNow [
	^ (self createList) checkSession; yourself
]

{ #category : #'command list type setting' }
WDCCommandListAllocator >> direct [
	self listType: AGPU_COMMAND_LIST_TYPE_DIRECT
]

{ #category : #'resource building' }
WDCCommandListAllocator >> findCommandQueue [
	queueType == #graphics ifTrue: [ ^ engine graphicsQueue ].
	self error: 'Unsupported command queue ', queueType printString
]

{ #category : #initialization }
WDCCommandListAllocator >> initialize [
	queueType := #graphics.
]

{ #category : #accessing }
WDCCommandListAllocator >> listType [
	^ listType
]

{ #category : #accessing }
WDCCommandListAllocator >> listType: anObject [
	listType := anObject
]

{ #category : #accessing }
WDCCommandListAllocator >> queue [
	^ queue
]

{ #category : #accessing }
WDCCommandListAllocator >> queueType [
	^ queueType
]

{ #category : #accessing }
WDCCommandListAllocator >> queueType: anObject [
	queueType := anObject
]

{ #category : #'as yet unclassified' }
WDCCommandListAllocator >> reset [
	self validHandle reset.
]
