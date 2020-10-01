Class {
	#name : #RWXLineLayout,
	#superclass : #RWLineLayout,
	#category : 'WodenEngine-Roassal-Layout'
}

{ #category : #hook }
RWXLineLayout >> getNewPositionFor: aValue [
	^ Float32x3 new x: aValue asFloat
]

{ #category : #hook }
RWXLineLayout >> sizeOf: anElement [
	^ anElement shape widthFor: anElement
]
