Class {
	#name : #WDESAbstractSceneNodeComponent,
	#superclass : #WDESComponentWithShape,
	#traits : 'TWDCTransformationManipulationMethods',
	#classTraits : 'TWDCTransformationManipulationMethods classTrait',
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

{ #category : #accessing }
WDESAbstractSceneNodeComponent >> position [
	^ localTransform position
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
WDESAbstractSceneNodeComponent >> translateTo: translation [
	localTransform translation: translation.
	self localTransformChanged
]

{ #category : #accessing }
WDESAbstractSceneNodeComponent >> validSceneNode [
	^ sceneNode ifNil: [ sceneNode := self createSceneNode ]
]
