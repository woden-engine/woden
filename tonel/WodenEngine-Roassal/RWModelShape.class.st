Class {
	#name : #RWModelShape,
	#superclass : #RWAbstractSolidShape,
	#instVars : [
		'modelName',
		'nodeName',
		'shapeNode',
		'engine'
	],
	#category : #'WodenEngine-Roassal-Core'
}

{ #category : #'as yet unclassified' }
RWModelShape class >> modelNamed: modelName [
	^ self new modelName: modelName; yourself
]

{ #category : #'as yet unclassified' }
RWModelShape class >> modelNamed: modelName node: nodeName [
	^ self new modelName: modelName; nodeName: nodeName; yourself
]

{ #category : #hooks }
RWModelShape >> buildRenderableFor: anElement view: aView [
	self assert: (engine isNil or: [engine == aView engine]).
	engine := aView engine.
	anElement sceneNode addChild: self validShapeNode.
	^ WDCNullRenderable new
]

{ #category : #computing }
RWModelShape >> depthFor: anElement [
	^ shapeNode localBoundingBox depth
]

{ #category : #computing }
RWModelShape >> heightFor: anElement [
	^ shapeNode localBoundingBox height
]

{ #category : #computing }
RWModelShape >> localCenterFor: anElement [
	^ self validShapeNode localBoundingBox center
]

{ #category : #accessing }
RWModelShape >> modelName [
	^ modelName
]

{ #category : #accessing }
RWModelShape >> modelName: anObject [
	modelName := anObject
]

{ #category : #accessing }
RWModelShape >> nodeName [
	^ nodeName
]

{ #category : #accessing }
RWModelShape >> nodeName: anObject [
	nodeName := anObject
]

{ #category : #'as yet unclassified' }
RWModelShape >> validEngine [
	^ engine ifNil: [engine := WDCEngine default]
]

{ #category : #hooks }
RWModelShape >> validModelLibraryFor: anEngine [
	^ anEngine resourceCache load3DModel: modelName
]

{ #category : #'as yet unclassified' }
RWModelShape >> validShapeNode [
	| modelLibrary |
	shapeNode ifNotNil: [ ^ shapeNode ].
	modelLibrary := self validModelLibraryFor: self validEngine. 
	^ shapeNode := nodeName
		ifNil: [ modelLibrary instanceDefaultSceneNode ]
		ifNotNil: [ modelLibrary instanceSceneNodeNamed: nodeName ].
	
]

{ #category : #computing }
RWModelShape >> widthFor: anElement [
	^ shapeNode localBoundingBox width
]
