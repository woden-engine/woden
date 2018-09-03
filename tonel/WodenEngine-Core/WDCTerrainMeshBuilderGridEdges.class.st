Class {
	#name : #WDCTerrainMeshBuilderGridEdges,
	#superclass : #Object,
	#instVars : [
		'left',
		'right',
		'bottom',
		'top'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #accessing }
WDCTerrainMeshBuilderGridEdges >> bottom [
	^ bottom
]

{ #category : #accessing }
WDCTerrainMeshBuilderGridEdges >> bottom: anObject [
	bottom := anObject
]

{ #category : #accessing }
WDCTerrainMeshBuilderGridEdges >> left [
	^ left
]

{ #category : #accessing }
WDCTerrainMeshBuilderGridEdges >> left: anObject [
	left := anObject
]

{ #category : #accessing }
WDCTerrainMeshBuilderGridEdges >> right [
	^ right
]

{ #category : #accessing }
WDCTerrainMeshBuilderGridEdges >> right: anObject [
	right := anObject
]

{ #category : #accessing }
WDCTerrainMeshBuilderGridEdges >> top [
	^ top
]

{ #category : #accessing }
WDCTerrainMeshBuilderGridEdges >> top: anObject [
	top := anObject
]
