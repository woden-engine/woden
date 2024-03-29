Class {
	#name : #WDCAbstractRenderingSceneObject,
	#superclass : #Object,
	#traits : 'TWDCSpatialSubdivisionDataStructureElement',
	#classTraits : 'TWDCSpatialSubdivisionDataStructureElement classTrait',
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
	^ boundingBox ifNil:[ boundingBox := self computeBoundingBox]
]

{ #category : #accessing }
WDCAbstractRenderingSceneObject >> boundingBox: anObject [
	boundingBox := anObject
]

{ #category : #accessing }
WDCAbstractRenderingSceneObject >> computeBoundingBox [
	self subclassResponsibility
]

{ #category : #accessing }
WDCAbstractRenderingSceneObject >> isLightSource [
	^ false
]

{ #category : #testing }
WDCAbstractRenderingSceneObject >> isOpaqueShadowCaster [
	^ false
]

{ #category : #testing }
WDCAbstractRenderingSceneObject >> isSpatialVolumeElement [
	^ true
]

{ #category : #accessing }
WDCAbstractRenderingSceneObject >> node [
	^ node
]

{ #category : #accessing }
WDCAbstractRenderingSceneObject >> node: anObject [
	node := anObject
]

{ #category : #'as yet unclassified' }
WDCAbstractRenderingSceneObject >> renderableChanged [
	boundingBox := nil.
]

{ #category : #testing }
WDCAbstractRenderingSceneObject >> spatialElementBoundingBox [
	^ boundingBox
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

{ #category : #caching }
WDCAbstractRenderingSceneObject >> transformChanged [
	boundingBox := nil.
]

{ #category : #'as yet unclassified' }
WDCAbstractRenderingSceneObject >> updateCommonGpuStateForFrame: frameIndex [
	spatialObject updateCommonGpuStateForFrame: frameIndex.
]

{ #category : #'as yet unclassified' }
WDCAbstractRenderingSceneObject >> updateGpuStateForFrame: frameIndex camera: camera [
	spatialObject updateGpuStateForFrame: frameIndex camera: camera.
]

{ #category : #accessing }
WDCAbstractRenderingSceneObject >> visible [
	^ spatialObject visible
]
