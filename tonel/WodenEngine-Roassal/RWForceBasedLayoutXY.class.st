Class {
	#name : #RWForceBasedLayoutXY,
	#superclass : #RWForceBasedLayout,
	#category : #'WodenEngine-Roassal-Layout'
}

{ #category : #hook }
RWForceBasedLayoutXY >> axisConstraints [
	^ WMVector3F x: 1.0 y: 1.0 z: 0.0
]

{ #category : #initialization }
RWForceBasedLayoutXY >> defaultInitialLayout [
	^ RWXYGridLayout new
]
