Class {
	#name : #RWXZGridLayout,
	#superclass : #RWGridLayout,
	#category : 'Woden2-Roassal-Layout'
}

{ #category : #hooks }
RWXZGridLayout >> xdirection [
	^ WMVector3F x: 1.0 y: 0.0 z: 0.0
]

{ #category : #hooks }
RWXZGridLayout >> ydirection [
	^ WMVector3F x: 0.0 y: 0.0 z: 1.0
]
