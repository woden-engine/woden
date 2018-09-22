Class {
	#name : #WDBBabylonMesh2D,
	#superclass : #Object,
	#instVars : [
		'vertices',
		'indices',
		'submeshes'
	],
	#category : #'WodenEngine-Babylon'
}

{ #category : #converting }
WDBBabylonMesh2D >> asBabylonShapeFor: aPompeiiDriver [
	^ self
]

{ #category : #'as yet unclassified' }
WDBBabylonMesh2D >> drawWithWodenCanvas: aCanvas [
	^ aCanvas drawWodenMesh2D: self
]

{ #category : #accessing }
WDBBabylonMesh2D >> indices [
	^ indices
]

{ #category : #accessing }
WDBBabylonMesh2D >> indices: anObject [
	indices := anObject
]

{ #category : #accessing }
WDBBabylonMesh2D >> submeshes [
	^ submeshes
]

{ #category : #accessing }
WDBBabylonMesh2D >> submeshes: anObject [
	submeshes := anObject
]

{ #category : #accessing }
WDBBabylonMesh2D >> vertices [
	^ vertices
]

{ #category : #accessing }
WDBBabylonMesh2D >> vertices: anObject [
	vertices := anObject
]
