Class {
	#name : #RWYZGridLayout,
	#superclass : #RWGridLayout,
	#category : 'Woden2-Roassal-Layout'
}

{ #category : #'as yet unclassified' }
RWYZGridLayout >> xdirection [
	^ WMVector3F x: 0.0 y: 1.0 z: 0.0
]

{ #category : #'as yet unclassified' }
RWYZGridLayout >> ydirection [
	^ WMVector3F x: 0.0 y: 0.0 z: 1.0
]
