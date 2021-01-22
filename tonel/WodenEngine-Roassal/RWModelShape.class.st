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
RWModelShape >> buildRenderableFor: anElement view: aView [
	shapeNode := ((self validModelLibraryFor: aView engine) instanceSceneNodeNamed: nodeName).
	anElement sceneNode addChild: shapeNode.
	^ WDCNullRenderable new
]

{ #category : #computing }
RWModelShape >> depthFor: anElement [
	^ (super depthFor: anElement) * shapeNode localBoundingBox depth
]

{ #category : #computing }
RWModelShape >> heightFor: anElement [
	^ (super heightFor: anElement) * shapeNode localBoundingBox height
]

{ #category : #computing }
RWModelShape >> localCenterFor: anElement [
	^ (self rawExtentFor: anElement) * shapeNode localBoundingBox center
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

{ #category : #computing }
RWModelShape >> rawExtentFor: element [
	^ Float32x3
		x: (super widthFor: element)
		y: (super heightFor: element)
		z: (super depthFor: element)
]

{ #category : #hooks }
RWModelShape >> validModelLibraryFor: anEngine [
	^ anEngine resourceCache load3DModel: modelName
]

{ #category : #computing }
RWModelShape >> widthFor: anElement [
	^ (super widthFor: anElement) * shapeNode localBoundingBox width
]
