Class {
	#name : #RWForceBasedLayoutOctTreeElement,
	#superclass : #WDCSpatialSubdivisionDataStructurePointElement,
	#instVars : [
		'node'
	],
	#category : #'WodenEngine-Roassal-Layout'
}

{ #category : #accessing }
RWForceBasedLayoutOctTreeElement >> node [
	^ node
]

{ #category : #accessing }
RWForceBasedLayoutOctTreeElement >> node: anObject [
	node := anObject.
	value := node position.
]
