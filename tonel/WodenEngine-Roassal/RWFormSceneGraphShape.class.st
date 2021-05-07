Class {
	#name : #RWFormSceneGraphShape,
	#superclass : #RWAbstractSolidShape,
	#instVars : [
		'renderable',
		'drawBlock',
		'backgroundColor',
		'borderColor'
	],
	#category : #'WodenEngine-Roassal-Core'
}

{ #category : #accessing }
RWFormSceneGraphShape >> backgroundColor [

	^ backgroundColor
]

{ #category : #accessing }
RWFormSceneGraphShape >> backgroundColor: anObject [

	backgroundColor := anObject
]

{ #category : #accessing }
RWFormSceneGraphShape >> borderColor [

	^ borderColor
]

{ #category : #accessing }
RWFormSceneGraphShape >> borderColor: anObject [

	borderColor := anObject
]

{ #category : #'as yet unclassified' }
RWFormSceneGraphShape >> buildRenderableFor: anElement view: aView [
	renderable := WDCFormSceneGraphRenderable for: aView engine.
	renderable
		makeTranslucentSorted;
		drawingSurfaceExtent: 512@512;
		scaleFactor: self scaleFactor;
		useUnitBox.
	self changed.
	^ renderable
]

{ #category : #updating }
RWFormSceneGraphShape >> changed [
	drawBlock ifNil: [ ^ self ].
	renderable ifNil: [ ^ self ].
	
	renderable buildSceneGraphWith: [ :builder |
		(builder withTransform: (FormSGAffineTransform scale: self scaleFactor) build: [
			| background |
			background := (builder rectangle: builder clippingBounds color: backgroundColor) ,
				(builder borderRectangle: builder clippingBounds color: borderColor width: 2).

			background , (drawBlock value: builder).
		])
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

{ #category : #initialization }
RWFormSceneGraphShape >> initialize [
	super initialize.
	backgroundColor := Color veryLightGray alpha: 0.3.
	borderColor := Color black.
]

{ #category : #accessing }
RWFormSceneGraphShape >> scaleFactor [
	^ 2.0
]

{ #category : #'changing shape' }
RWFormSceneGraphShape >> shapeTransformFor: anElement [
	^ ReversibleAffineTransform3dF32 identity
		scaleByX: (self widthFor: anElement) * 0.5
		y: (self heightFor: anElement) * 0.5
		z: (self depthFor: anElement) * 0.5
]
