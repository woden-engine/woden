"
I take care of binding all of the per-instance data of a group of objects.
"
Class {
	#name : #WDSGSpatialObjectInstanceGroup,
	#superclass : #WDSGSpatialObject,
	#instVars : [
		'pendingUpdates',
		'childOffsetDictionary',
		'depthSorted',
		'lastForwardDirection'
	],
	#category : #'WodenEngine-Scene-Graph'
}

{ #category : #'as yet unclassified' }
WDSGSpatialObjectInstanceGroup >> addChild: aChild [
	super addChild: aChild.
	updatedPerFrame ifFalse: [
		self assert: children last == aChild.
		childOffsetDictionary at: aChild put: (children size - 1) * WTGenericObjectState structureSize.
		pendingUpdates add: aChild.
	]
]

{ #category : #'as yet unclassified' }
WDSGSpatialObjectInstanceGroup >> addPendingUpdate: aNode [
	updatedPerFrame ifFalse: [ pendingUpdates add: aNode ]
]

{ #category : #'as yet unclassified' }
WDSGSpatialObjectInstanceGroup >> createInstanceStateBuffer [
	^ WDCStreamingStorageBufferVector new
			capacity: (32 max: children size);
			elementType: WTGenericObjectState;
			engine: scene engine;
			yourself.
]

{ #category : #rendering }
WDSGSpatialObjectInstanceGroup >> createSceneDependentData [
	| engine instanceBuffer |
	gpuObjectStates ifNotNil: [ ^ self ].
	
	engine := scene engine.
	instanceBuffer := updatedPerFrame ifFalse: [ self createInstanceStateBuffer ].
	gpuObjectStates := engine frameBufferingCollect: [:frameIndex | {
		scene genericObjectStatePool allocate.
		updatedPerFrame ifTrue: [ self createInstanceStateBuffer ] ifFalse: [ instanceBuffer ]
	}].
	
	objectStateBindings := gpuObjectStates collect: [ :state |
		| binding |
		binding := scene shaderSignature newObjectState
			bind: 0 uniformBufferElement: state first;
			bind: 1 storageBufferElement: state second;
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

	renderable ifNotNil: [
		renderableSceneData := renderable createSceneDependentDataFor: scene engine into: objectStateBindings
	].

]

{ #category : #rendering }
WDSGSpatialObjectInstanceGroup >> depthSortFor: aCamera [
	| forwardDirection |
	forwardDirection := (aCamera renderTransform matrix * renderTransform matrix) thirdColumn negated.
	"(lastForwardDirection closeTo: forwardDirection) ifTrue: [ ^ self ]."
	lastForwardDirection := forwardDirection.
		
	children do: #updateRenderTransform.
	self renderPriority >= WDSGNode renderPriorityTranslucentSorted ifTrue: [
		children sort: [ :a :b |
			(forwardDirection dot: a renderTransform translation) < (forwardDirection dot: b renderTransform translation)
		]
	] ifFalse: [ 
		children sort: [ :a :b |
			(forwardDirection dot: a renderTransform translation) > (forwardDirection dot: b renderTransform translation)
		]
	]
]

{ #category : #accessing }
WDSGSpatialObjectInstanceGroup >> depthSorted [
	^ depthSorted
]

{ #category : #accessing }
WDSGSpatialObjectInstanceGroup >> depthSorted: anObject [
	depthSorted := anObject
]

{ #category : #'as yet unclassified' }
WDSGSpatialObjectInstanceGroup >> initialize [
	super initialize.
	pendingUpdates := Set new.
	childOffsetDictionary := Dictionary new.
	depthSorted := false.
	lastForwardDirection := WMVector3F new.
]

{ #category : #'as yet unclassified' }
WDSGSpatialObjectInstanceGroup >> instanceWasRemoved: aNode [
	updatedPerFrame ifFalse: [
		pendingUpdates remove: aNode ifAbsent: [].
		childOffsetDictionary remove: aNode ifAbsent: [] 
	]
]

{ #category : #testing }
WDSGSpatialObjectInstanceGroup >> isInstanceGroup [
	^ true
]

{ #category : #'as yet unclassified' }
WDSGSpatialObjectInstanceGroup >> offsetOfInstanceChild: child [
	^ childOffsetDictionary at: child
]

{ #category : #rendering }
WDSGSpatialObjectInstanceGroup >> performGpuStateUpdateWithCamera: aCamera [
	| currentGpuState instanceStateBuffer instanceStateSize instanceStateOffset instanceStatePointer |
	objectState transform: renderTransform.
	depthSorted ifTrue: [ self depthSortFor: aCamera ].
	
	currentGpuState := self currentGpuObjectState.
	currentGpuState first value: objectState.
	
	instanceStateBuffer := currentGpuState second.
	instanceStateBuffer ensureCapacityForAtLeast: children size keepOldData: true.
	
	instanceStateSize := instanceStateBuffer elementSize.
	instanceStatePointer := instanceStateBuffer validPointer getHandle.
	updatedPerFrame ifTrue: [ 
		children doWithIndex: [ :child :index |
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
	
	renderable ifNotNil: [
		renderable performGpuStateUpdateFor: scene engine frameIndex: scene engine bufferingFrameIndex into: renderableSceneData
	]
]

{ #category : #'as yet unclassified' }
WDSGSpatialObjectInstanceGroup >> removeChild: aChild [
	updatedPerFrame ifTrue: [ aChild visible: false ].
	super removeChild: aChild.
	updatedPerFrame ifFalse: [
		childOffsetDictionary removeKey: aChild.
		pendingUpdates remove: aChild ifAbsent: [].
	].

]

{ #category : #rendering }
WDSGSpatialObjectInstanceGroup >> renderOn: stateTracker [
	renderable ifNil: [ ^ self ].
	
	stateTracker
		useShaderResources: self currentObjectStateBinding;
		objectBlendingMode: blendingMode.
		
	renderable renderOn: stateTracker instanceCount: children size baseInstance: 0 baseVertex: 0
]

{ #category : #rendering }
WDSGSpatialObjectInstanceGroup >> renderOn: commandList mode: renderMode submode: submode [
	renderable ifNil: [ ^ self ].
	
	commandList
		useShaderResources: self currentObjectStateBinding validHandle.
		
	renderable renderOn: commandList mode: renderMode submode: submode instanceCount: children size baseInstance: 0 baseVertex: 0
]
