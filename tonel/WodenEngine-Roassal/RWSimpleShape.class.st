Class {
	#name : #RWSimpleShape,
	#superclass : #RWShape,
	#instVars : [
		'width',
		'height',
		'depth'
	],
	#category : 'WodenEngine-Roassal-Core'
}

{ #category : #'as yet unclassified' }
RWSimpleShape class >> defaultMaterial [
	^ 'materials/basic/white.json'
]

{ #category : #hooks }
RWSimpleShape >> baseShapeDescriptor [
	self subclassResponsibility
]

{ #category : #computing }
RWSimpleShape >> boundingBoxFor: element [
	| hw hh hd |
	hw := (self widthFor: element) * 0.5.
	hh := (self heightFor: element) * 0.5.
	hd := (self depthFor: element) * 0.5.
	^ WMBox3DF
		nx: hw negated ny: hh negated nz: hd negated
		px: hw py: hh pz: hd
]

{ #category : #hooks }
RWSimpleShape >> buildRenderableFor: anElement view: aView [
	| baseShape instance |
	baseShape := aView baseShapeNodeFor: self baseShapeDescriptor ifAbsentPut: [ self createBaseShapeNodeForView: aView ].
	instance := WTSLocalShapedSpatialObject new.
	instance shapeTransform: (self shapeTransformFor: anElement);
		color: (self colorFor: anElement).
	baseShape addChild: instance.
	anElement replaceSceneNode: instance.
	^ nil
]

{ #category : #'changing shape' }
RWSimpleShape >> changedElement: element sceneNode: sceneNode renderable: renderable [
	sceneNode isInstance ifFalse: [ ^ self ].
	sceneNode shapeTransform: (self shapeTransformFor: element);
		color: (self colorFor: element).
]

{ #category : #hooks }
RWSimpleShape >> createBaseShapeNodeForView: aView [
	self subclassResponsibility
]

{ #category : #accessing }
RWSimpleShape >> depth: aValueOrASymbolOrAOneArgBlock [
	"aValueOrASymbolOrAOneArgBlock is applied on the object model"
	self depthElement: [ :anElement | aValueOrASymbolOrAOneArgBlock rwValue: anElement model ]
]

{ #category : #accessing }
RWSimpleShape >> depthElement: aValueOrASymbolOrAOneArgBlock [
	depth := aValueOrASymbolOrAOneArgBlock
]

{ #category : #computing }
RWSimpleShape >> depthFor: anElement [
	^ depth rwValue: anElement
]

{ #category : #accessing }
RWSimpleShape >> height: aValueOrAOneArgBlock [
	"aValueOrAOneArgBlock is applied on the object model"
	self heightElement: [ :anElement | aValueOrAOneArgBlock rwValue: anElement model ]
]

{ #category : #accessing }
RWSimpleShape >> heightElement: aValueOrASymbolOrAOneArgBlock [
	height := aValueOrASymbolOrAOneArgBlock
]

{ #category : #computing }
RWSimpleShape >> heightFor: anElement [
	^ height rwValue: anElement
]

{ #category : #initialization }
RWSimpleShape >> initialize [
	super initialize.
	width := 1.0.
	height := 1.0.
	depth := 1.0.
	color := Color white.
]

{ #category : #accessing }
RWSimpleShape >> material [
	^ self class defaultMaterial
]

{ #category : #hooks }
RWSimpleShape >> shapeTransformFor: anElement [
	^ WMReversibleAffineTransformF identity
		scaleByX: (self widthFor: anElement) asFloat
		y: (self heightFor: anElement) asFloat
		z: (self depthFor: anElement) asFloat
]

{ #category : #accessing }
RWSimpleShape >> size: aBlockOrASymbolOrAValue [
	self height: aBlockOrASymbolOrAValue.
	self width: aBlockOrASymbolOrAValue.
	self depth: aBlockOrASymbolOrAValue.
]

{ #category : #accessing }
RWSimpleShape >> width: aValueOrASymbolOrAOneArgBlock [
	"aValueOrASymbolOrAOneArgBlock is applied on the object model"
	self widthElement: [ :anElement | aValueOrASymbolOrAOneArgBlock rwValue: anElement model ]
]

{ #category : #accessing }
RWSimpleShape >> widthElement: aValueOrASymbolOrAOneArgBlock [
	width := aValueOrASymbolOrAOneArgBlock
]

{ #category : #computing }
RWSimpleShape >> widthFor: anElement [
	^ width rwValue: anElement
]

{ #category : #'base shape construction' }
RWSimpleShape >> wodenMaterialForView: aView [
	^ aView engine resourceCache loadMaterial: self class defaultMaterial
]
