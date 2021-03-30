Class {
	#name : #WDEFileReferenceMaterial,
	#superclass : #WDEMaterial,
	#instVars : [
		'path',
		'renderingMaterial'
	],
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #comparing }
WDEFileReferenceMaterial >> = other [
	^ self class == other class and: [ path = other path ]

]

{ #category : #converting }
WDEFileReferenceMaterial >> asRenderingMaterialForSession: levelEditorSession engine: engine [
	^ renderingMaterial ifNil: [ renderingMaterial := levelEditorSession gameSettings createRenderingMaterialForPath: path engine: engine ]
]

{ #category : #serialization }
WDEFileReferenceMaterial >> encodeJsonKeyValues [
	^ super encodeJsonKeyValues , {
		#path . path
	}
]

{ #category : #testing }
WDEFileReferenceMaterial >> hasTexture [
	^ renderingMaterial isNotNil and: [ renderingMaterial hasTexture ]
]

{ #category : #comparing }
WDEFileReferenceMaterial >> hash [
	^ self class identityHash bitXor: (path hash)
]

{ #category : #serialization }
WDEFileReferenceMaterial >> loadFromJson: jsonData context: context [
	super loadFromJson: jsonData context: context.
	path := jsonData at: #path ifAbsent: [ path ].
]

{ #category : #'as yet unclassified' }
WDEFileReferenceMaterial >> makeThumbnailForSession: levelEditorSession engine: engine [
	^ levelEditorSession gameSettings makeThumbnailForMaterialWithPath: path engine: engine
]

{ #category : #accessing }
WDEFileReferenceMaterial >> path [

	^ path
]

{ #category : #accessing }
WDEFileReferenceMaterial >> path: anObject [

	path := anObject
]
