Class {
	#name : #RWYLineLayout,
	#superclass : #RWLineLayout,
	#category : 'WodenEngine-Roassal-Layout'
}

{ #category : #hook }
RWYLineLayout >> getNewPositionFor: aValue [
	^ Float32x3 new y: aValue asFloat
]

{ #category : #hook }
RWYLineLayout >> sizeOf: anElement [
	^ anElement shape heightFor: anElement
]
