Class {
	#name : #WDESAbstractSceneNodeComponent,
	#superclass : #WDESComponentWithShape,
	#instVars : [
		'sceneNode',
		'localTransform'
	],
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #accessing }
WDESAbstractSceneNodeComponent >> addedToScene: scene [
	ownerEntity validSceneNode addChild: self validSceneNode.
	sceneNode transform: localTransform.
]

{ #category : #accessing }
WDESAbstractSceneNodeComponent >> createSceneNode [
	| node |
	node := WDSGSpatialObject new.
	node renderable: self renderable.
	^ node
]

{ #category : #directions }
WDESAbstractSceneNodeComponent >> forwardDirection [
	^ localTransform transformVector3: (WMVector3F z: 1.0)
]

{ #category : #initialization }
WDESAbstractSceneNodeComponent >> initialize [
	super initialize.
	localTransform := WMReversibleAffineTransformF identity.
]

{ #category : #accessing }
WDESAbstractSceneNodeComponent >> localTransform [
	^ localTransform
]

{ #category : #accessing }
WDESAbstractSceneNodeComponent >> localTransform: anObject [
	localTransform := anObject asWMReversibleAffineTransformF copy.
	self localTransformChanged.
]

{ #category : #initialization }
WDESAbstractSceneNodeComponent >> localTransformChanged [
	sceneNode ifNotNil: [ sceneNode localTransform: localTransform ]
]

{ #category : #accessing }
WDESAbstractSceneNodeComponent >> makeTranslucent [
	self renderable makeTranslucent
]

{ #category : #accessing }
WDESAbstractSceneNodeComponent >> makeTranslucentSorted [
	self renderable makeTranslucentSorted
]

{ #category : #initialization }
WDESAbstractSceneNodeComponent >> position: aPosition [
	localTransform translation: aPosition.
	self localTransformChanged.
]

{ #category : #accessing }
WDESAbstractSceneNodeComponent >> removedFromScene: scene [
	sceneNode ifNotNil: [ sceneNode removeFromScene ]
]

{ #category : #accessing }
WDESAbstractSceneNodeComponent >> renderable [
	self subclassResponsibility
]

{ #category : #transforming }
WDESAbstractSceneNodeComponent >> rotateDegreesOnX: degrees [
	localTransform rotateDegreesOnX: degrees.
	self localTransformChanged
]

{ #category : #transforming }
WDESAbstractSceneNodeComponent >> rotateDegreesOnY: degrees [
	localTransform rotateDegreesOnY: degrees.
	self localTransformChanged
]

{ #category : #transforming }
WDESAbstractSceneNodeComponent >> rotateDegreesOnZ: degrees [
	localTransform rotateDegreesOnZ: degrees.
	self localTransformChanged
]

{ #category : #transforming }
WDESAbstractSceneNodeComponent >> rotateRadiansOnX: degrees [
	localTransform rotateRadiansOnX: degrees.
	self localTransformChanged
]

{ #category : #transforming }
WDESAbstractSceneNodeComponent >> rotateRadiansOnY: degrees [
	localTransform rotateRadiansOnY: degrees.
	self localTransformChanged
]

{ #category : #transforming }
WDESAbstractSceneNodeComponent >> rotateRadiansOnZ: degrees [
	localTransform rotateRadiansOnZ: degrees.
	self localTransformChanged
]

{ #category : #transforming }
WDESAbstractSceneNodeComponent >> translateBy: translation [
	localTransform translateBy: translation.
	self localTransformChanged
]

{ #category : #transforming }
WDESAbstractSceneNodeComponent >> translateByX: translation [
	self translateBy: (WMVector3F x: translation)
]

{ #category : #transforming }
WDESAbstractSceneNodeComponent >> translateByX: x y: y z: z [
	self translateBy: (WMVector3F x: x y: y z: z)
]

{ #category : #transforming }
WDESAbstractSceneNodeComponent >> translateByY: translation [
	self translateBy: (WMVector3F y: translation)
]

{ #category : #transforming }
WDESAbstractSceneNodeComponent >> translateByZ: translation [
	self translateBy: (WMVector3F new z: translation)
]

{ #category : #transforming }
WDESAbstractSceneNodeComponent >> translateTo: translation [
	localTransform translation: translation.
	self localTransformChanged
]

{ #category : #transforming }
WDESAbstractSceneNodeComponent >> translateToX: newX [
	self translateTo: (self position x: newX)
]

{ #category : #transforming }
WDESAbstractSceneNodeComponent >> translateToX: newX y: newY z: newZ [ 
	self translateTo: (WMVector3F x: newX y: newY z: newZ)
]

{ #category : #transforming }
WDESAbstractSceneNodeComponent >> translateToY: newY [
	self translateTo: (self position y: newY)
]

{ #category : #transforming }
WDESAbstractSceneNodeComponent >> translateToZ: newZ [
	self translateTo: (self position z: newZ)
]

{ #category : #accessing }
WDESAbstractSceneNodeComponent >> validSceneNode [
	^ sceneNode ifNil: [ sceneNode := self createSceneNode ]
]
