Class {
	#name : #WDCLineMeshComponent,
	#superclass : #WDCAbstractMeshComponent,
	#instVars : [
		'startPoint',
		'endPoint'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #drawing }
WDCLineMeshComponent >> buildMeshOn: aMeshBuilder [
	aMeshBuilder
		useFlatColorMaterial;
		addLineFrom: startPoint to: endPoint
]

{ #category : #accessing }
WDCLineMeshComponent >> endPoint [
	^ endPoint
]

{ #category : #accessing }
WDCLineMeshComponent >> endPoint: anObject [
	endPoint := anObject
]

{ #category : #initialization }
WDCLineMeshComponent >> initialize [
	super initialize.
	startPoint := WMVector3F zero.
	endPoint := WMVector3F zero.
]

{ #category : #accessing }
WDCLineMeshComponent >> startPoint [
	^ startPoint
]

{ #category : #accessing }
WDCLineMeshComponent >> startPoint: anObject [
	startPoint := anObject
]
