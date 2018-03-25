Class {
	#name : #RWLineLayout,
	#superclass : #RWLayout,
	#instVars : [
		'gap'
	],
	#category : 'WodenEngine-Roassal-Layout'
}

{ #category : #configuration }
RWLineLayout >> defaultGap [
	^ 1
]

{ #category : #hook }
RWLineLayout >> getNewPositionFor: anElement [
	self subclassResponsibility 
]

{ #category : #'initialize-release' }
RWLineLayout >> initialize [ 
	super initialize.
	gap := self defaultGap
]

{ #category : #public }
RWLineLayout >> on: elements [
	| index |
	index  := 0.
	elements do: [ :el |
		el translateTo: (self getNewPositionFor: index).
		index := index + (self sizeOf: el) + gap ]	
]

{ #category : #hook }
RWLineLayout >> sizeOf: anElement [
	self subclassResponsibility
]
