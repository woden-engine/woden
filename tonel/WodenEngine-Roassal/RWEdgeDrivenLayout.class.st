Class {
	#name : #RWEdgeDrivenLayout,
	#superclass : #RWLayout,
	#instVars : [
		'edges'
	],
	#category : #'WodenEngine-Roassal-Layout'
}

{ #category : #accessing }
RWEdgeDrivenLayout >> edges [
	^ edges
]

{ #category : #accessing }
RWEdgeDrivenLayout >> edges: aCollection [
	edges := aCollection
]

{ #category : #public }
RWEdgeDrivenLayout >> on: elements [
	"Override this method to particularize the layout"
	elements ifEmpty: [ ^ self ].
	self executeOnElements: elements
]

{ #category : #accessing }
RWEdgeDrivenLayout >> setEdgesFromElements: elements [
	elements isEmpty ifTrue: [ ^ self ].
	self edges: ((elements flatCollect: #incomingEdges)
				select: [ :anEdge | elements includes: anEdge from ])

]
