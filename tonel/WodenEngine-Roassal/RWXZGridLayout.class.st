Class {
	#name : #RWXZGridLayout,
	#superclass : #RWGridLayout,
	#category : 'WodenEngine-Roassal-Layout'
}

{ #category : #hooks }
RWXZGridLayout >> xdirection [
	^ Float32x3 x: 1.0 y: 0.0 z: 0.0
]

{ #category : #hooks }
RWXZGridLayout >> ydirection [
	^ Float32x3 x: 0.0 y: 0.0 z: 1.0
]
