Class {
	#name : #WDSGSceneCommonGPUStateRenderingComponent,
	#superclass : #WDSGSceneRenderingDependencyComponent,
	#traits : 'TWDCRenderingDependencyGraphNode',
	#classTraits : 'TWDCRenderingDependencyGraphNode classTrait',
	#category : #'WodenEngine-Scene-Rendering'
}

{ #category : #'rendering process stages' }
WDSGSceneCommonGPUStateRenderingComponent >> prepareRendering [
	scene updateCommonGPUState
]
