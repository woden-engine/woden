Class {
	#name : #WDCMaterialReference,
	#superclass : #Object,
	#instVars : [
		'name',
		'fallbackMaterial'
	],
	#category : #'WodenEngine-Core-Material'
}

{ #category : #'as yet unclassified' }
WDCMaterialReference >> engineChangedTo: anEngine [
	^ anEngine resourceCache loadMaterial: name fallback: [ self fallbackMaterial engineChangedTo: anEngine ]
]

{ #category : #accessing }
WDCMaterialReference >> fallbackMaterial [
	^ fallbackMaterial ifNil: [ fallbackMaterial := WDCMetallicRoughnessMaterial new ]
]

{ #category : #accessing }
WDCMaterialReference >> fallbackMaterial: anObject [
	fallbackMaterial := anObject
]

{ #category : #accessing }
WDCMaterialReference >> name [
	^ name
]

{ #category : #accessing }
WDCMaterialReference >> name: anObject [
	name := anObject
]

{ #category : #enumerating }
WDCMaterialReference >> precacheResources [
]

{ #category : #'as yet unclassified' }
WDCMaterialReference >> requiresTangentSpaceData [
	^ true
]

{ #category : #'as yet unclassified' }
WDCMaterialReference >> setupRenderableTranslucency: renderable [
	^ fallbackMaterial setupRenderableTranslucency: renderable
]
