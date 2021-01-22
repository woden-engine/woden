Class {
	#name : #RWSimpleShape,
	#superclass : #RWAbstractSolidShape,
	#category : #'WodenEngine-Roassal-Core'
}

{ #category : #'as yet unclassified' }
RWSimpleShape class >> defaultMaterial [
	^ 'materials/basic/white.json'
]

{ #category : #hooks }
RWSimpleShape >> baseShapeDescriptor [
	self subclassResponsibility
]

{ #category : #hooks }
RWSimpleShape >> buildRenderableFor: anElement view: aView [
	| baseShape instance |
	baseShape := anElement parentGroup baseShapeNodeFor: self baseShapeDescriptor ifAbsentPut: [ self createBaseShapeNodeForView: aView ].
	instance := WDSGLocalShapedSpatialInstanceObject new.
	instance shapeTransform: (self shapeTransformFor: anElement);
		color: (self colorFor: anElement).
	baseShape addChild: instance.
	anElement replaceSceneNode: instance.
	^ nil
]

{ #category : #'changing shape' }
RWSimpleShape >> changedElement: element sceneNode: sceneNode renderable: renderable [
	sceneNode isLocalSpatialNode ifFalse: [ ^ self ].
	sceneNode shapeTransform: (self shapeTransformFor: element)
]

{ #category : #hooks }
RWSimpleShape >> createBaseShapeNodeForView: aView [
	self subclassResponsibility
]

{ #category : #hooks }
RWSimpleShape >> shapeTransformFor: anElement [
	^ ReversibleAffineTransform3dF32 identity
		scaleByX: (self widthFor: anElement) asFloat
		y: (self heightFor: anElement) asFloat
		z: (self depthFor: anElement) asFloat
]
