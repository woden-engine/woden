Class {
	#name : #RWForceBasedLayoutYZ,
	#superclass : #RWForceBasedLayout,
	#category : #'WodenEngine-Roassal-Layout'
}

{ #category : #hook }
RWForceBasedLayoutYZ >> axisConstraints [
	^ WMVector3F x: 0.0 y: 1.0 z: 1.0
]

{ #category : #initialization }
RWForceBasedLayoutYZ >> defaultInitialLayout [
	^ RWYZGridLayout new
]
