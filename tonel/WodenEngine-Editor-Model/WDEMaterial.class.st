Class {
	#name : #WDEMaterial,
	#superclass : #WDELevelElement,
	#instVars : [
		'materialIndex'
	],
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #converting }
WDEMaterial >> asRenderingMaterialForSession: levelEditorSession engine: engine [
	^ engine resourceCache defaultMaterial
]

{ #category : #testing }
WDEMaterial >> hasTexture [
	^ false
]

{ #category : #thumbnail }
WDEMaterial >> makeThumbnailForSession: levelEditorSession engine: engine [
	^ nil
]

{ #category : #accessing }
WDEMaterial >> materialIndex [

	^ materialIndex
]

{ #category : #accessing }
WDEMaterial >> materialIndex: anObject [

	materialIndex := anObject
]
