Class {
	#name : #WTAthensPath,
	#superclass : #AthensPath,
	#instVars : [
		'firstSegment',
		'isJustText'
	],
	#category : 'Woden2-Athens'
}

{ #category : #'as yet unclassified' }
WTAthensPath >> checkForOnlyTextSegments: segment [
	| currentSegment |
	isJustText := true.
	currentSegment := segment.
	[ currentSegment isNotNil ] whileTrue: [
		(currentSegment isMove or: [ currentSegment isTextSegment ]) ifFalse: [ 
			isJustText := false.
			^ self
		].
	
		currentSegment := currentSegment next.
	]
]

{ #category : #accessing }
WTAthensPath >> firstSegment [
	^ firstSegment
]

{ #category : #accessing }
WTAthensPath >> firstSegment: anObject [
	firstSegment := anObject.
	self checkForOnlyTextSegments: firstSegment
]

{ #category : #'as yet unclassified' }
WTAthensPath >> isJustText [
	^ isJustText
]

{ #category : #'as yet unclassified' }
WTAthensPath >> paintFillsUsing: aPaint on: anAthensCanvas [ 
	
	"This method is a part of rendering dispatch  Canvas->receiver->paint"
	
	^ aPaint athensFillPath: self on: anAthensCanvas
]

{ #category : #'as yet unclassified' }
WTAthensPath >> sendCommandsTo: aPathBuilder [
	aPathBuilder absolute.
	firstSegment ifNotNil: [ firstSegment sendCommandsTo: aPathBuilder ].
]
