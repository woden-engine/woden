Class {
	#name : #WDEFileReferenceMaterial,
	#superclass : #WDEMaterial,
	#instVars : [
		'path'
	],
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #accessing }
WDEFileReferenceMaterial >> path [

	^ path
]

{ #category : #accessing }
WDEFileReferenceMaterial >> path: anObject [

	path := anObject
]
