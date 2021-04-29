Class {
	#name : #WDEMetallicRoughnessMaterial,
	#superclass : #WDEMaterial,
	#instVars : [
		'occlusionFactor',
		'metallicFactor',
		'roughnessFactor',
		'emissionTexture',
		'normalTexture',
		'occlusionRoughnessMetallicTexture',
		'renderingMaterial',
		'baseColorTexture',
		'baseColorFactor',
		'emissionFactor'
	],
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #comparing }
WDEMetallicRoughnessMaterial >> = other [
	^ self class == other class and: [ 
		baseColorFactor = other baseColorFactor and: [
		emissionFactor = other emissionFactor and: [
		occlusionFactor = other occlusionFactor and: [
		roughnessFactor = other roughnessFactor and: [
		metallicFactor = other metallicFactor and: [
		baseColorTexture = other baseColorTexture and: [
		emissionTexture = other emissionTexture and: [
		normalTexture = other normalTexture and: [
		occlusionRoughnessMetallicTexture = other occlusionRoughnessMetallicTexture ]]]]]]]]]

]

{ #category : #converting }
WDEMetallicRoughnessMaterial >> asRenderingMaterialForEngine: engine [
	^ renderingMaterial ifNil: [ renderingMaterial := self createRenderingMaterialFor: engine ]
]

{ #category : #converting }
WDEMetallicRoughnessMaterial >> asRenderingMaterialForSession: levelEditorSession engine: engine [
	^ renderingMaterial ifNil: [ renderingMaterial := self createRenderingMaterialFor: engine ]
]

{ #category : #accessing }
WDEMetallicRoughnessMaterial >> baseColorFactor [

	^ baseColorFactor
]

{ #category : #accessing }
WDEMetallicRoughnessMaterial >> baseColorFactor: anObject [

	baseColorFactor := anObject asFloat32x4
]

{ #category : #accessing }
WDEMetallicRoughnessMaterial >> baseColorTexture [

	^ baseColorTexture
]

{ #category : #accessing }
WDEMetallicRoughnessMaterial >> baseColorTexture: anObject [

	baseColorTexture := anObject
]

{ #category : #converting }
WDEMetallicRoughnessMaterial >> createRenderingMaterialFor: engine [
	| material |
	material := WDCMetallicRoughnessMaterial for: engine.
	material
		albedoColor: baseColorFactor;
		emissionFactor: emissionFactor;
		occlusionFactor: occlusionFactor;
		roughnessFactor: roughnessFactor;
		metallicFactor: metallicFactor.
	^ material
]

{ #category : #accessing }
WDEMetallicRoughnessMaterial >> emissionFactor [

	^ emissionFactor
]

{ #category : #accessing }
WDEMetallicRoughnessMaterial >> emissionFactor: anObject [

	emissionFactor := anObject asFloat32x3
]

{ #category : #accessing }
WDEMetallicRoughnessMaterial >> emissionTexture [

	^ emissionTexture
]

{ #category : #accessing }
WDEMetallicRoughnessMaterial >> emissionTexture: anObject [

	emissionTexture := anObject
]

{ #category : #serialization }
WDEMetallicRoughnessMaterial >> encodeJsonKeyValues [
	^ super encodeJsonKeyValues , {
		#baseColorFactor . baseColorFactor encodeForJSON.
		#emissionFactor . emissionFactor encodeForJSON.
		#occlusionFactor . occlusionFactor.
		#roughnessFactor . roughnessFactor.
		#metallicFactor . metallicFactor.
		#baseColorTexture . baseColorTexture ifNil: [0] ifNotNil: [ baseColorTexture textureIndex ].
		#emissionTexture . emissionTexture ifNil: [0] ifNotNil: [ emissionTexture textureIndex ].
		#normalTexture . normalTexture ifNil: [0] ifNotNil: [ normalTexture textureIndex ].
		#occlusionRoughnessMetallicTexture . occlusionRoughnessMetallicTexture ifNil: [0] ifNotNil: [ occlusionRoughnessMetallicTexture textureIndex ].
	}
]

{ #category : #comparing }
WDEMetallicRoughnessMaterial >> hash [
	^ self class identityHash bitXor: ( 
		baseColorFactor hash bitXor: (
		emissionFactor hash bitXor: (
		occlusionFactor hash bitXor: (
		roughnessFactor hash bitXor: (
		metallicFactor hash bitXor: (
		baseColorTexture hash bitXor: (
		emissionTexture hash bitXor: (
		normalTexture hash bitXor: (
		occlusionRoughnessMetallicTexture hash )))))))))
]

{ #category : #initialization }
WDEMetallicRoughnessMaterial >> initialize [
	super initialize.
	baseColorFactor := Float32x4 ones.
	emissionFactor := Float32x3 zeros.
	occlusionFactor := 1.0.
	metallicFactor := 1.0.
	roughnessFactor := 1.0.
]

{ #category : #serialization }
WDEMetallicRoughnessMaterial >> loadFromJson: jsonData context: context [
	super loadFromJson: jsonData context: context.
	jsonData at: #baseColorFactor ifPresent: [ :color | baseColorFactor := Float32x4 loadFromJson: color ].
	jsonData at: #emissionFactor ifPresent: [ :color | emissionFactor := Float32x3 loadFromJson: color ].
	
	occlusionFactor := jsonData at: #occlusionFactor ifAbsent: [ occlusionFactor ].
	roughnessFactor := jsonData at: #roughnessFactor ifAbsent: [ roughnessFactor ].
	metallicFactor := jsonData at: #metallicFactor ifAbsent: [ metallicFactor ].
	jsonData at: #baseColorTexture ifPresent: [ :index | baseColorTexture := context getTextureWithIndex: index ].
	jsonData at: #emissionTexture ifPresent: [ :index | emissionTexture := context getTextureWithIndex: index ].
	jsonData at: #normalTexture ifPresent: [ :index | normalTexture := context getTextureWithIndex: index ].
	jsonData at: #occlusionRoughnessMetallicTexture ifPresent: [ :index | occlusionRoughnessMetallicTexture := context getTextureWithIndex: index ].

]

{ #category : #thumbnail }
WDEMetallicRoughnessMaterial >> makeThumbnailForSession: levelEditorSession engine: engine [
	^ (Form extent: 16@16 depth: 32) fillColor: baseColorFactor asColor
]

{ #category : #accessing }
WDEMetallicRoughnessMaterial >> metallicFactor [

	^ metallicFactor
]

{ #category : #accessing }
WDEMetallicRoughnessMaterial >> metallicFactor: anObject [

	metallicFactor := anObject
]

{ #category : #accessing }
WDEMetallicRoughnessMaterial >> normalTexture [

	^ normalTexture
]

{ #category : #accessing }
WDEMetallicRoughnessMaterial >> normalTexture: anObject [

	normalTexture := anObject
]

{ #category : #accessing }
WDEMetallicRoughnessMaterial >> occlusionFactor [

	^ occlusionFactor
]

{ #category : #accessing }
WDEMetallicRoughnessMaterial >> occlusionFactor: anObject [

	occlusionFactor := anObject
]

{ #category : #accessing }
WDEMetallicRoughnessMaterial >> occlusionRoughnessMetallicTexture [

	^ occlusionRoughnessMetallicTexture
]

{ #category : #accessing }
WDEMetallicRoughnessMaterial >> occlusionRoughnessMetallicTexture: anObject [

	occlusionRoughnessMetallicTexture := anObject
]

{ #category : #accessing }
WDEMetallicRoughnessMaterial >> roughnessFactor [

	^ roughnessFactor
]

{ #category : #accessing }
WDEMetallicRoughnessMaterial >> roughnessFactor: anObject [

	roughnessFactor := anObject
]
