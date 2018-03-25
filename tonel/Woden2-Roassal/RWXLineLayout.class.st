Class {
	#name : #RWXLineLayout,
	#superclass : #RWLineLayout,
	#category : 'Woden2-Roassal-Layout'
}

{ #category : #hook }
RWXLineLayout >> getNewPositionFor: aValue [
	^ WMVector3F new x: aValue asFloat
]

{ #category : #hook }
RWXLineLayout >> sizeOf: anElement [
	^ anElement shape widthFor: anElement
]
