Class {
	#name : #WDCAbstractRenderingSceneObject,
	#superclass : #Object,
	#instVars : [
		'spatialObject',
		'boundingBox',
		'node'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Rendering'
}

{ #category : #accessing }
WDCAbstractRenderingSceneObject >> boundingBox [
	^ boundingBox
]

{ #category : #accessing }
WDCAbstractRenderingSceneObject >> boundingBox: anObject [
	boundingBox := anObject
]

{ #category : #accessing }
WDCAbstractRenderingSceneObject >> isLightSource [
	^ false
]

{ #category : #accessing }
WDCAbstractRenderingSceneObject >> node [
	^ node
]

{ #category : #accessing }
WDCAbstractRenderingSceneObject >> node: anObject [
	node := anObject
]

{ #category : #accessing }
WDCAbstractRenderingSceneObject >> spatialObject [
	^ spatialObject
]

{ #category : #accessing }
WDCAbstractRenderingSceneObject >> spatialObject: anObject [
	spatialObject := anObject
]

{ #category : #accessing }
WDCAbstractRenderingSceneObject >> transform [
	^ spatialObject transform
]

{ #category : #'as yet unclassified' }
WDCAbstractRenderingSceneObject >> updateCommonGpuStateForFrame: frameBufferingIndex [
	spatialObject updateCommonGpuStateForFrame: frameBufferingIndex.
]
