Class {
	#name : #RWForceBasedLayoutXZ,
	#superclass : #RWForceBasedLayout,
	#category : #'WodenEngine-Roassal-Layout'
}

{ #category : #hook }
RWForceBasedLayoutXZ >> axisConstraints [
	^ WMVector3F x: 1.0 y: 0.0 z: 1.0
]

{ #category : #initialization }
RWForceBasedLayoutXZ >> defaultInitialLayout [
	^ RWXZGridLayout new
]
