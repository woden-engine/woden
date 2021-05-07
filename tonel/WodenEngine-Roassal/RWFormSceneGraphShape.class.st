Class {
	#name : #RWFormSceneGraphShape,
	#superclass : #RWAbstractSolidShape,
	#instVars : [
		'renderable',
		'drawBlock'
	],
	#category : #'WodenEngine-Roassal-Core'
}

{ #category : #'as yet unclassified' }
RWFormSceneGraphShape >> buildRenderableFor: anElement view: aView [
	renderable := WDCFormSceneGraphRenderable for: aView engine.
	renderable useUnitBox.
	self changed.
	^ renderable
]

{ #category : #updating }
RWFormSceneGraphShape >> changed [
	drawBlock ifNil: [ ^ self ].
	renderable ifNil: [ ^ self ].
	
	renderable buildSceneGraphWith: [ :builder |
		drawBlock value: builder
	]
]

{ #category : #'changing shape' }
RWFormSceneGraphShape >> changedElement: element sceneNode: sceneNode renderable: theRenderable [
]

{ #category : #'as yet unclassified' }
RWFormSceneGraphShape >> drawWith: aBlock [
	drawBlock := aBlock.
	self changed.
]

{ #category : #'changing shape' }
RWFormSceneGraphShape >> shapeTransformFor: anElement [
	^ ReversibleAffineTransform3dF32 identity
		scaleByX: (self widthFor: anElement) * 0.5
		y: (self heightFor: anElement) * 0.5
		z: (self depthFor: anElement) * 0.5
]
