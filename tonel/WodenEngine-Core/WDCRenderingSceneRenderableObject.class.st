Class {
	#name : #WDCRenderingSceneRenderableObject,
	#superclass : #WDCAbstractRenderingSceneObject,
	#instVars : [
		'renderable'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Rendering'
}

{ #category : #accessing }
WDCRenderingSceneRenderableObject >> computeBoundingBox [
	self validateRenderable.
	^ spatialObject computeBoundingBoxForRenderable: renderable
]

{ #category : #testing }
WDCRenderingSceneRenderableObject >> isOpaqueShadowCaster [
	^ renderable isOpaqueShadowCaster
]

{ #category : #accessing }
WDCRenderingSceneRenderableObject >> renderOn: stateTracker [
	self validateRenderable.
	spatialObject renderRenderable: renderable with: stateTracker

]

{ #category : #accessing }
WDCRenderingSceneRenderableObject >> renderPriority [
	^ renderable renderPriority
]

{ #category : #accessing }
WDCRenderingSceneRenderableObject >> renderable [
	^ renderable
]

{ #category : #accessing }
WDCRenderingSceneRenderableObject >> renderable: anObject [
	renderable := anObject
]

{ #category : #'as yet unclassified' }
WDCRenderingSceneRenderableObject >> updateCommonGpuStateForFrame: frameIndex [
	super updateCommonGpuStateForFrame: frameIndex.
	renderable updateCommonGpuStateForFrame: frameIndex.
]

{ #category : #accessing }
WDCRenderingSceneRenderableObject >> validateRenderable [
	renderable validateForNode: node.
]
