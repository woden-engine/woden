Class {
	#name : #RWModelShape,
	#superclass : #RWAbstractSolidShape,
	#instVars : [
		'modelName',
		'nodeName',
		'shapeNode'
	],
	#category : #'WodenEngine-Roassal-Core'
}

{ #category : #'as yet unclassified' }
RWModelShape class >> modelNamed: modelName node: nodeName [
	^ self new modelName: modelName; nodeName: nodeName; yourself
]

{ #category : #hooks }
RWModelShape >> buildRenderableFor: anElement view: aView parentSceneNode: parentSceneNode [
	shapeNode := ((self validModelLibraryFor: aView engine) instanceSceneNodeNamed: nodeName).
	parentSceneNode addChild: shapeNode.
	aView validScene add: parentSceneNode.
	^ WDCNullRenderable new
]

{ #category : #computing }
RWModelShape >> heightFor: anElement [
	^ (super heightFor: anElement) * shapeNode localBoundingBox height
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

{ #category : #hooks }
RWModelShape >> validModelLibraryFor: anEngine [
	^ anEngine resourceCache load3DModel: modelName
]
