Class {
	#name : #WDEFaceMaterialAttributes,
	#superclass : #Object,
	#instVars : [
		'material',
		'scale',
		'offset',
		'rotation'
	],
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #converting }
WDEFaceMaterialAttributes >> asRenderMaterialForEngine: engine levelEditorSession: levelEditorSession [
	^ material
		ifNotNil: [ material asRenderingMaterialForSession: levelEditorSession engine: engine   ]
		ifNil: [ engine resourceCache defaultMaterial ].
]

{ #category : #accessing }
WDEFaceMaterialAttributes >> buildLevelElementPropertyPageWith: builder [
	builder
		vector2PropertyNamed: 'Texture Scale' selector: #scale;
		vector2PropertyNamed: 'Texture Offset' selector: #offset;
		scalarPropertyNamed: 'Texture Rotation' selector: #rotationt
]

{ #category : #serialization }
WDEFaceMaterialAttributes >> encodeForJSON [
	^ Dictionary newFromPairs: self encodeJsonKeyValues
]

{ #category : #serialization }
WDEFaceMaterialAttributes >> encodeJsonKeyValues [
	^ {
		#material . material ifNil: [0] ifNotNil: [material materialIndex].
		#scale . scale encodeForJSON.
		#offset . offset encodeForJSON.
		#rotation . rotation
	}
]

{ #category : #testing }
WDEFaceMaterialAttributes >> hasTexture [
	^ material isNotNil and: [ material hasTexture ]
]

{ #category : #initialization }
WDEFaceMaterialAttributes >> initialize [
	super initialize.
	scale := Float32x2 ones.
	offset := Float32x2 zeros.
	rotation := 0.
]

{ #category : #serialization }
WDEFaceMaterialAttributes >> loadFromJson: jsonData context: context [
	jsonData at: 'material' ifPresent: [ :index |
		material := context getMaterialWithIndex: index
	].
	jsonData at: 'textureScale' ifPresent: [ :data |
		scale := Float32x2 loadFromJson: data.
	].
	jsonData at: 'textureOffset' ifPresent: [ :data |
		offset := Float32x2 loadFromJson: data.
	].
	rotation := jsonData at: 'rotation' ifAbsent: [ 0 ]
]

{ #category : #accessing }
WDEFaceMaterialAttributes >> material [

	^ material
]

{ #category : #accessing }
WDEFaceMaterialAttributes >> material: anObject [

	material := anObject
]

{ #category : #memento }
WDEFaceMaterialAttributes >> materialStateMemento [
	^ material
]

{ #category : #accessing }
WDEFaceMaterialAttributes >> offset [

	^ offset
]

{ #category : #accessing }
WDEFaceMaterialAttributes >> offset: anObject [

	offset := anObject
]

{ #category : #memento }
WDEFaceMaterialAttributes >> restoreMaterialStateMemento: memento [
	material := memento
]

{ #category : #accessing }
WDEFaceMaterialAttributes >> rotation [

	^ rotation
]

{ #category : #accessing }
WDEFaceMaterialAttributes >> rotation: anObject [

	rotation := anObject
]

{ #category : #accessing }
WDEFaceMaterialAttributes >> scale [

	^ scale
]

{ #category : #accessing }
WDEFaceMaterialAttributes >> scale: anObject [

	scale := anObject
]

{ #category : #'as yet unclassified' }
WDEFaceMaterialAttributes >> textureTransform [
	| scaleRotationMat |
	scaleRotationMat := (Float32x3x3 zRotation: rotation) * (Float32x3x3 scale: (Float32x3 xy: scale z: 1)).
	
	^ Float32x3x3 columns: {
		scaleRotationMat firstColumn.
		scaleRotationMat secondColumn.
		Float32x3 xy: offset z: 1
	}
]
