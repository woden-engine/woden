Class {
	#name : #WDPPompeiiMesh2D,
	#superclass : #Object,
	#instVars : [
		'vertices',
		'indices',
		'submeshes'
	],
	#category : #'WodenEngine-Pompeii'
}

{ #category : #converting }
WDPPompeiiMesh2D >> asPompeiiShapeFor: aPompeiiDriver [
	^ self
]

{ #category : #'as yet unclassified' }
WDPPompeiiMesh2D >> drawWithWodenCanvas: aCanvas [
	^ aCanvas drawWodenMesh2D: self
]

{ #category : #accessing }
WDPPompeiiMesh2D >> indices [
	^ indices
]

{ #category : #accessing }
WDPPompeiiMesh2D >> indices: anObject [
	indices := anObject
]

{ #category : #accessing }
WDPPompeiiMesh2D >> submeshes [
	^ submeshes
]

{ #category : #accessing }
WDPPompeiiMesh2D >> submeshes: anObject [
	submeshes := anObject
]

{ #category : #accessing }
WDPPompeiiMesh2D >> vertices [
	^ vertices
]

{ #category : #accessing }
WDPPompeiiMesh2D >> vertices: anObject [
	vertices := anObject
]
