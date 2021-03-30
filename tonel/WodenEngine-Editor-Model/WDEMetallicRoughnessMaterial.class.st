Class {
	#name : #WDEMetallicRoughnessMaterial,
	#superclass : #WDEMaterial,
	#instVars : [
		'baseColor',
		'emissionColor',
		'occlusionFactor',
		'metallicFactor',
		'roughnessFactor',
		'emissionTexture',
		'normalTexture',
		'occlusionRoughnessMetallicTexture',
		'renderingMaterial',
		'baseColorTexture'
	],
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #comparing }
WDEMetallicRoughnessMaterial >> = other [
	^ self class == other class and: [ 
		baseColor = other baseColor and: [
		emissionColor = other emissionColor and: [
		occlusionFactor = other occlusionFactor and: [
		roughnessFactor = other roughnessFactor and: [
		metallicFactor = other metallicFactor and: [
		baseColorTexture = other baseColorTexture and: [
		emissionTexture = other emissionTexture and: [
		normalTexture = other normalTexture and: [
		occlusionRoughnessMetallicTexture = other occlusionRoughnessMetallicTexture ]]]]]]]]]

]

{ #category : #converting }
WDEMetallicRoughnessMaterial >> asRenderingMaterialForSession: levelEditorSession engine: engine [
	^ renderingMaterial ifNil: [ renderingMaterial := self createRenderingMaterialFor: engine ]
]

{ #category : #accessing }
WDEMetallicRoughnessMaterial >> baseColor [

	^ baseColor
]

{ #category : #accessing }
WDEMetallicRoughnessMaterial >> baseColor: anObject [

	baseColor := anObject asFloat32x4
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
		albedoColor: baseColor;
		emissionColor: emissionColor;
		occlusionFactor: occlusionFactor;
		roughnessFactor: roughnessFactor;
		metallicFactor: metallicFactor.
	^ material
]

{ #category : #accessing }
WDEMetallicRoughnessMaterial >> emissionColor [

	^ emissionColor
]

{ #category : #accessing }
WDEMetallicRoughnessMaterial >> emissionColor: anObject [

	emissionColor := anObject asFloat32x3
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
		#baseColor . baseColor encodeForJSON.
		#emissionColor . emissionColor encodeForJSON.
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
		baseColor hash bitXor: (
		emissionColor hash bitXor: (
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
	baseColor := Float32x4 ones.
	emissionColor := Float32x3 zeros.
	occlusionFactor := 1.0.
	metallicFactor := 1.0.
	roughnessFactor := 1.0.
]

{ #category : #serialization }
WDEMetallicRoughnessMaterial >> loadFromJson: jsonData context: context [
	super loadFromJson: jsonData context: context.
	jsonData at: #baseColor ifPresent: [ :color | baseColor := Float32x4 loadFromJson: color ].
	jsonData at: #emissionColor ifPresent: [ :color | emissionColor := Float32x3 loadFromJson: color ].
	
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
	^ (Form extent: 16@16 depth: 32) fillColor: baseColor asColor
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
