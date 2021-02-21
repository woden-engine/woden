Class {
	#name : #WDEMaterial,
	#superclass : #WDELevelElement,
	#instVars : [
		'materialIndex'
	],
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #converting }
WDEMaterial >> asRenderingMaterialFor: engine [
	^ engine resourceCache defaultMaterial
]

{ #category : #accessing }
WDEMaterial >> materialIndex [

	^ materialIndex
]

{ #category : #accessing }
WDEMaterial >> materialIndex: anObject [

	materialIndex := anObject
]
