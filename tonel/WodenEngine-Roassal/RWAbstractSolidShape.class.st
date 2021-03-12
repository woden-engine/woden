Class {
	#name : #RWAbstractSolidShape,
	#superclass : #RWShape,
	#instVars : [
		'width',
		'height',
		'depth'
	],
	#category : #'WodenEngine-Roassal-Core'
}

{ #category : #'as yet unclassified' }
RWAbstractSolidShape >> areaFor: anElement [
	| extent |
	extent := anElement boundingBox extent.
	^ 2*((extent x*extent y) + (extent y * extent z) + (extent y*extent z))
]

{ #category : #computing }
RWAbstractSolidShape >> boundingBoxFor: element [
	^ BoxF32
		center: (self localCenterFor: element)
		halfExtent: (self halfExtentFor: element)

]

{ #category : #accessing }
RWAbstractSolidShape >> depth: aValueOrASymbolOrAOneArgBlock [
	"aValueOrASymbolOrAOneArgBlock is applied on the object model"
	self depthElement: [ :anElement | aValueOrASymbolOrAOneArgBlock rwValue: anElement model ]
]

{ #category : #accessing }
RWAbstractSolidShape >> depthElement: aValueOrASymbolOrAOneArgBlock [
	depth := aValueOrASymbolOrAOneArgBlock
]

{ #category : #computing }
RWAbstractSolidShape >> depthFor: anElement [
	^ depth rwValue: anElement
]

{ #category : #computing }
RWAbstractSolidShape >> extentFor: element [
	^ Float32x3
		x: (self widthFor: element)
		y: (self heightFor: element)
		z: (self depthFor: element)
]

{ #category : #computing }
RWAbstractSolidShape >> halfExtentFor: element [
	^ (self extentFor: element) * 0.5
]

{ #category : #accessing }
RWAbstractSolidShape >> height: aValueOrAOneArgBlock [
	"aValueOrAOneArgBlock is applied on the object model"
	self heightElement: [ :anElement | aValueOrAOneArgBlock rwValue: anElement model ]
]

{ #category : #accessing }
RWAbstractSolidShape >> heightElement: aValueOrASymbolOrAOneArgBlock [
	height := aValueOrASymbolOrAOneArgBlock
]

{ #category : #computing }
RWAbstractSolidShape >> heightFor: anElement [
	^ height rwValue: anElement
]

{ #category : #initialization }
RWAbstractSolidShape >> initialize [
	super initialize.
	width := 1.0.
	height := 1.0.
	depth := 1.0.
	color := Color white.
]

{ #category : #computing }
RWAbstractSolidShape >> localCenterFor: anElement [
	^ Float32x3 zeros
]

{ #category : #accessing }
RWAbstractSolidShape >> material [
	^ self class defaultMaterial
]

{ #category : #accessing }
RWAbstractSolidShape >> size: aBlockOrASymbolOrAValue [
	self height: aBlockOrASymbolOrAValue.
	self width: aBlockOrASymbolOrAValue.
	self depth: aBlockOrASymbolOrAValue.
]

{ #category : #'as yet unclassified' }
RWAbstractSolidShape >> volumeFor: anElement [
	| extent |
	extent := anElement boundingBox extent.
	^ extent x * extent y * extent z
]

{ #category : #accessing }
RWAbstractSolidShape >> width: aValueOrASymbolOrAOneArgBlock [
	"aValueOrASymbolOrAOneArgBlock is applied on the object model"
	self widthElement: [ :anElement | aValueOrASymbolOrAOneArgBlock rwValue: anElement model ]
]

{ #category : #accessing }
RWAbstractSolidShape >> widthElement: aValueOrASymbolOrAOneArgBlock [
	width := aValueOrASymbolOrAOneArgBlock
]

{ #category : #computing }
RWAbstractSolidShape >> widthFor: anElement [
	^ width rwValue: anElement
]

{ #category : #'base shape construction' }
RWAbstractSolidShape >> wodenMaterialForView: aView [
	^ aView engine resourceCache loadMaterial: self class defaultMaterial
]
