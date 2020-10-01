Class {
	#name : #RWXYGridLayout,
	#superclass : #RWGridLayout,
	#category : 'WodenEngine-Roassal-Layout'
}

{ #category : #hooks }
RWXYGridLayout >> xdirection [
	^ Float32x3 x: 1.0 y: 0.0 z: 0.0
]

{ #category : #hooks }
RWXYGridLayout >> ydirection [
	^ Float32x3 x: 0.0 y: 1.0 z: 0.0
]
