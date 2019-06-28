Class {
	#name : #WDCInstanceGroupSpatialObject,
	#superclass : #WDCAbstractGPUSpatialObject,
	#instVars : [
		'instances'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-SpatialObject'
}

{ #category : #initialization }
WDCInstanceGroupSpatialObject >> initialize [
	super initialize.
	instances := OrderedCollection new.
]

{ #category : #accessing }
WDCInstanceGroupSpatialObject >> instances [
	^ instances
]

{ #category : #rendering }
WDCInstanceGroupSpatialObject >> renderRenderable: renderable with: stateTracker [
	stateTracker
		useShaderResources: self currentObjectStateBinding.
		
	renderable
		renderOn: stateTracker instanceCount: instances size baseInstance: 0 baseVertex: 0
]
