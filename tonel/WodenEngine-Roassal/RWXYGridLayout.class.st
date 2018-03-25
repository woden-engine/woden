Class {
	#name : #RWXYGridLayout,
	#superclass : #RWGridLayout,
	#category : 'WodenEngine-Roassal-Layout'
}

{ #category : #hooks }
RWXYGridLayout >> xdirection [
	^ WMVector3F x: 1.0 y: 0.0 z: 0.0
]

{ #category : #hooks }
RWXYGridLayout >> ydirection [
	^ WMVector3F x: 0.0 y: 1.0 z: 0.0
]
