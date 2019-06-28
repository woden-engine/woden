Class {
	#name : #WDCInstanceGroupSpatialObject,
	#superclass : #WDCAbstractGPUSpatialObject,
	#instVars : [
		'instances',
		'updatedPerFrame',
		'childOffsetDictionary',
		'pendingUpdates',
		'depthSorted',
		'lastForwardDirection'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-SpatialObject'
}

{ #category : #adding }
WDCInstanceGroupSpatialObject >> addChild: aChild [
	self assert: aChild owner isNil.
	instances add: aChild.
	aChild owner: self.
	updatedPerFrame ifFalse: [
		self assert: instances last == aChild.
		childOffsetDictionary at: aChild put: (instances size - 1) * WTGenericObjectState structureSize.
		pendingUpdates add: aChild.
	]
	
]

{ #category : #adding }
WDCInstanceGroupSpatialObject >> addPendingUpdate: aNode [
	updatedPerFrame ifFalse: [ pendingUpdates add: aNode ]
]

{ #category : #'as yet unclassified' }
WDCInstanceGroupSpatialObject >> childChanged: aChild [
	self addPendingUpdate: aChild
]

{ #category : #accessing }
WDCInstanceGroupSpatialObject >> createEngineDependantData [
	| instanceBuffer shaderSignature |
	gpuObjectStates ifNotNil: [ ^ self ].
	
	instanceBuffer := updatedPerFrame ifFalse: [ self createInstanceStateBuffer ].
	gpuObjectStates := engine frameBufferingCollect: [:frameIndex | {
		engine resourceCache genericObjectStatePool allocate.
		updatedPerFrame ifTrue: [ self createInstanceStateBuffer ] ifFalse: [ instanceBuffer ]
	}].
	
	shaderSignature := WDCSceneRenderingShaderSignature for: engine.
	objectStateBindings := gpuObjectStates collect: [ :gpuObjectState |
		| binding |
		binding := shaderSignature newObjectState
			bind: 0 uniformBufferElement: gpuObjectState first;
			bind: 1 storageBufferElement: gpuObjectState second;
			yourself.
		updatedPerFrame ifTrue: [
			state second reallocatedAction: [ :newVector |
				binding bind: 1 storageBufferElement: newVector
			].
		].
		binding
	].

	updatedPerFrame ifFalse: [
		instanceBuffer reallocatedAction: [ :newVector |
			engine graphicsQueue finishExecution.
			objectStateBindings do: [ :binding | binding bind: 1 storageBufferElement: newVector ]
		]
	].

]

{ #category : #accessing }
WDCInstanceGroupSpatialObject >> createInstanceStateBuffer [
	^ WDCStreamingStorageBufferVector new
			capacity: (32 max: instances size);
			elementType: WTGenericObjectState;
			engine: engine;
			yourself.
]

{ #category : #accessing }
WDCInstanceGroupSpatialObject >> depthSorted [
	^ depthSorted
]

{ #category : #accessing }
WDCInstanceGroupSpatialObject >> depthSorted: anObject [
	depthSorted := anObject
]

{ #category : #initialization }
WDCInstanceGroupSpatialObject >> initialize [
	super initialize.
	instances := OrderedCollection new.
	pendingUpdates := Set new.
	childOffsetDictionary := Dictionary new.
	depthSorted := false.
	lastForwardDirection := WMVector3F new.
]

{ #category : #accessing }
WDCInstanceGroupSpatialObject >> instances [
	^ instances
]

{ #category : #accessing }
WDCInstanceGroupSpatialObject >> instances: anObject [
	instances := anObject
]

{ #category : #adding }
WDCInstanceGroupSpatialObject >> removeChild: aChild [
	self assert: aChild owner == self.
	updatedPerFrame ifTrue: [ aChild visible: false ].
	instances remove: aChild.
	aChild owner: nil.
	updatedPerFrame ifFalse: [
		childOffsetDictionary removeKey: aChild.
		pendingUpdates remove: aChild ifAbsent: [].
	].
]

{ #category : #rendering }
WDCInstanceGroupSpatialObject >> renderRenderable: renderable with: stateTracker [
	stateTracker
		useShaderResources: self currentObjectStateBinding.
		
	renderable
		renderOn: stateTracker instanceCount: instances size baseInstance: 0 baseVertex: 0
]

{ #category : #'as yet unclassified' }
WDCInstanceGroupSpatialObject >> updateCommonGpuStateForFrame: frameIndex [
	depthSorted ifFalse: [ self updateInstancesGPUStates. ].

]

{ #category : #'as yet unclassified' }
WDCInstanceGroupSpatialObject >> updateInstancesGPUStates [
	| currentGpuState instanceStateBuffer instanceStateSize instanceStatePointer instanceStateOffset |
	currentGpuState := self currentGpuObjectState.
	currentGpuState first value: state.
	
	instanceStateBuffer := currentGpuState second.
	instanceStateBuffer ensureCapacityForAtLeast: instances size keepOldData: true.
	
	instanceStateSize := instanceStateBuffer elementSize.
	instanceStatePointer := instanceStateBuffer validPointer getHandle.
	updatedPerFrame ifTrue: [ 
		instances doWithIndex: [ :child :index |
			instanceStateOffset := (index-1) * instanceStateSize.
			child writeGPUStateInto: instanceStatePointer at: instanceStateOffset
		].
	] ifFalse: [
		pendingUpdates do: [ :child |
			instanceStateOffset := childOffsetDictionary at: child.
			child writeGPUStateInto: instanceStatePointer at: instanceStateOffset			
		].
		pendingUpdates removeAll
	].

]

{ #category : #accessing }
WDCInstanceGroupSpatialObject >> updatedPerFrame [
	^ updatedPerFrame
]

{ #category : #accessing }
WDCInstanceGroupSpatialObject >> updatedPerFrame: anObject [
	updatedPerFrame := anObject
]
