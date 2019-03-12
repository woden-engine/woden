Class {
	#name : #WDCAbstractShaderStage,
	#superclass : #Object,
	#instVars : [
		'entryPointName',
		'engine',
		'shaderLibrary',
		'properties',
		'dependantPipelines',
		'dependantPipelinesMutex'
	],
	#classVars : [
		'StageNameToClassMap'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Shaders'
}

{ #category : #'class initialization' }
WDCAbstractShaderStage class >> classForStageName: stageName [
	^ StageNameToClassMap at: stageName
]

{ #category : #'class initialization' }
WDCAbstractShaderStage class >> initialize [
	StageNameToClassMap := Dictionary new.
	self allSubclassesDo: [ :sc |
		sc stageName ifNotNil: [ 
			StageNameToClassMap at: sc stageName put: sc
		]
	]
]

{ #category : #accessing }
WDCAbstractShaderStage class >> stageName [
	^ nil
]

{ #category : #adding }
WDCAbstractShaderStage >> addDependantPipelineState: state [
	dependantPipelinesMutex critical: [
		dependantPipelines add: state
	]
]

{ #category : #'pipeline state building' }
WDCAbstractShaderStage >> agpuStageType [
	self subclassResponsibility
]

{ #category : #'pipeline state building' }
WDCAbstractShaderStage >> attachToPipelineBuilder: builder [
	builder attachShaderWithEntryPoint: shaderLibrary validHandle type: self agpuStageType entry_point: entryPointName asString
]

{ #category : #accessing }
WDCAbstractShaderStage >> engine [
	^ engine
]

{ #category : #accessing }
WDCAbstractShaderStage >> engine: anObject [
	engine := anObject
]

{ #category : #accessing }
WDCAbstractShaderStage >> entryPointName [
	^ entryPointName
]

{ #category : #accessing }
WDCAbstractShaderStage >> entryPointName: anObject [
	entryPointName := anObject
]

{ #category : #initialization }
WDCAbstractShaderStage >> initialize [
	super initialize.
	dependantPipelinesMutex := Semaphore forMutualExclusion.
	dependantPipelines := WeakSet new.
	
]

{ #category : #accessing }
WDCAbstractShaderStage >> properties [
	^ properties
]

{ #category : #accessing }
WDCAbstractShaderStage >> properties: anObject [
	properties := anObject
]

{ #category : #accessing }
WDCAbstractShaderStage >> propertyAt: key ifAbsent: aBlock [
	^ properties ifNil: [ aBlock value ]
		ifNotNil: [ properties at: key ifAbsent: aBlock ]
]

{ #category : #actions }
WDCAbstractShaderStage >> reload [
	dependantPipelinesMutex critical: [
		dependantPipelines do: #reload
	].
	
]

{ #category : #accessing }
WDCAbstractShaderStage >> shaderLibrary [
	^ shaderLibrary
]

{ #category : #accessing }
WDCAbstractShaderStage >> shaderLibrary: anObject [
	shaderLibrary := anObject
]

{ #category : #accessing }
WDCAbstractShaderStage >> stageName [
	^ self class stageName
]
