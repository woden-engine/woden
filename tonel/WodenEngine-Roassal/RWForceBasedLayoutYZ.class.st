Class {
	#name : #RWForceBasedLayoutYZ,
	#superclass : #RWForceBasedLayout,
	#category : #'WodenEngine-Roassal-Layout'
}

{ #category : #hook }
RWForceBasedLayoutYZ >> axisConstraints [
	^ Float32x3 x: 0.0 y: 1.0 z: 1.0
]

{ #category : #initialization }
RWForceBasedLayoutYZ >> defaultInitialLayout [
	^ RWYZGridLayout new
]
