Class {
	#name : #WDCMeshWithExtraDeformationRenderable,
	#superclass : #WDCDeformableRenderable,
	#instVars : [
		'mesh'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #accessing }
WDCMeshWithExtraDeformationRenderable >> boundingBox [
	^ mesh boundingBox.
]

{ #category : #'as yet unclassified' }
WDCMeshWithExtraDeformationRenderable >> engine: anEngine [
	super engine: anEngine.
	mesh engine: anEngine
]

{ #category : #'as yet unclassified' }
WDCMeshWithExtraDeformationRenderable >> exportModelWith: exporter [
	^ mesh exportModelWith: exporter
]

{ #category : #accessing }
WDCMeshWithExtraDeformationRenderable >> mesh [
	^ mesh
]

{ #category : #accessing }
WDCMeshWithExtraDeformationRenderable >> mesh: anObject [
	mesh := anObject
]

{ #category : #copying }
WDCMeshWithExtraDeformationRenderable >> postCopy [
	super postCopy.
	mesh := mesh copyForResourceCacheInstancing.
]

{ #category : #enumerating }
WDCMeshWithExtraDeformationRenderable >> precacheResources [
	super precacheResources.
	mesh precacheResources.
]

{ #category : #rendering }
WDCMeshWithExtraDeformationRenderable >> renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [
	stateTracker withDeformationState: self deformationState do: [ 
		stateTracker useShaderResources: deformationState currentRenderableStateBinding.
		mesh renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex
	].

]
