Class {
	#name : #RWYZGridLayout,
	#superclass : #RWGridLayout,
	#category : 'WodenEngine-Roassal-Layout'
}

{ #category : #'as yet unclassified' }
RWYZGridLayout >> xdirection [
	^ Float32x3 x: 0.0 y: 1.0 z: 0.0
]

{ #category : #'as yet unclassified' }
RWYZGridLayout >> ydirection [
	^ Float32x3 x: 0.0 y: 0.0 z: 1.0
]
