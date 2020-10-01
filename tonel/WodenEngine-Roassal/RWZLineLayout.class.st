Class {
	#name : #RWZLineLayout,
	#superclass : #RWLineLayout,
	#category : 'WodenEngine-Roassal-Layout'
}

{ #category : #hook }
RWZLineLayout >> getNewPositionFor: aValue [
	^ Float32x3 new z: aValue asFloat
]

{ #category : #hook }
RWZLineLayout >> sizeOf: anElement [
	^ anElement shape depthFor: anElement
]
