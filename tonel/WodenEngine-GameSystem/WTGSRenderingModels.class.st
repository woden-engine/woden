Class {
	#name : #WTGSRenderingModels,
	#superclass : #WTGSComponent,
	#instVars : [
		'invalidWireModel',
		'invalidSolidModel',
		'invalidTexturedModel',
		'wireModelBuilder',
		'wireModel',
		'wireModelMaterial',
		'solidModelBuilder',
		'solidModel',
		'solidModelMaterial',
		'texturedModelBuilder',
		'texturedModel'
	],
	#category : 'WodenEngine-GameSystem-Level'
}

{ #category : #'as yet unclassified' }
WTGSRenderingModels class >> fuelIgnoredInstanceVariableNames [
	^ #('invalidWireModel' 'invalidSolidModel' 'invalidTexturedModel' 'wireModelBuilder' 'wireModel' 'wireModelMaterial' 'solidModelBuilder' 'solidModel' 'solidModelMaterial' 'texturedModelBuilder' 'texturedModel')
]

{ #category : #adding }
WTGSRenderingModels >> addedToEntity: anEntity [
	super addedToEntity: anEntity.
	anEntity ensureSpatialObject.
	self addedToScene: anEntity scene.
]

{ #category : #adding }
WTGSRenderingModels >> addedToScene: scene [
	| nodeComponent |
	scene ifNil: [ ^ self ].
	nodeComponent := entity sceneNodeComponent.
	nodeComponent node renderable: self
]

{ #category : #'as yet unclassified' }
WTGSRenderingModels >> bestModel [
	entity scene ifNil: [
		self halt.
	].

	^ self texturedModelFor: entity scene engine
]

{ #category : #accessing }
WTGSRenderingModels >> bucket [
	^ #renderingModels
]

{ #category : #'extra per object rendering data' }
WTGSRenderingModels >> createSceneDependentDataFor: engine into: bindings [
	^ nil
]

{ #category : #rendering }
WTGSRenderingModels >> createSolidModel [
	solidModelBuilder
		clear;
		currentMaterial: solidModelMaterial.
	
	(entity components at: #modeling) do: [ :model |
		model buildSolidModelInto: solidModelBuilder 
	].
		
	solidModel := solidModelBuilder mesh.
	invalidSolidModel := false.
	^ solidModel
]

{ #category : #rendering }
WTGSRenderingModels >> createSolidModelBuilderFor: anEngine [
	solidModelBuilder := WTDynamicGenericMeshBuilder for: anEngine.
	solidModelMaterial := anEngine resourceCache loadMaterial: 'materials/basic/white.json'.
]

{ #category : #rendering }
WTGSRenderingModels >> createTexturedModel [
	| brushFaces |
	texturedModelBuilder
		clear.
	
	brushFaces := OrderedCollection new.
	(entity components at: #modeling) select: #isBrush thenDo: [ :brush |
		brushFaces addAll: brush faces
	].

	brushFaces sort: [ :a :b | a material <= b material ].
	brushFaces do: [:face | face buildTexturedModelInto: texturedModelBuilder].

	(entity components at: #modeling) do: [ :model |
		model isBrush ifFalse: [ model buildTexturedModelInto: texturedModelBuilder ] 
	].
		
	texturedModel := texturedModelBuilder mesh.
	invalidTexturedModel := false.
	^ texturedModel
]

{ #category : #rendering }
WTGSRenderingModels >> createTexturedModelBuilderFor: anEngine [
	texturedModelBuilder := WTDynamicGenericMeshBuilder for: anEngine.
]

{ #category : #rendering }
WTGSRenderingModels >> createWireModel [
	wireModelBuilder
		clear;
		currentMaterial: wireModelMaterial.
	
	(entity components at: #modeling) do: [ :model |
		model buildWireModelInto: wireModelBuilder 
	].
		
	wireModel := wireModelBuilder mesh.
	invalidWireModel := false.
	^ wireModel
]

{ #category : #rendering }
WTGSRenderingModels >> createWireModelBuilderFor: anEngine [
	wireModelBuilder := WTDynamicGenericMeshBuilder for: anEngine.
	wireModelMaterial := anEngine resourceCache loadMaterial: 'materials/basic/flat.json'.
]

{ #category : #serialization }
WTGSRenderingModels >> fuelAfterMaterialization [
	self invalidate
]

{ #category : #initialization }
WTGSRenderingModels >> initialize [
	self invalidate
]

{ #category : #rendering }
WTGSRenderingModels >> invalidate [
	invalidWireModel := true.
	invalidSolidModel := true.
	invalidTexturedModel := true.
]

{ #category : #rendering }
WTGSRenderingModels >> invalidateTexturedModel [
	invalidTexturedModel := true.
]

{ #category : #'as yet unclassified' }
WTGSRenderingModels >> isSingleton [
	^ true
]

{ #category : #'as yet unclassified' }
WTGSRenderingModels >> isUsedInPlayMode [
	^ false
]

{ #category : #rendering }
WTGSRenderingModels >> modelForSubMode: submode [
	| engine |
	engine := entity scene engine.
	engine ifNil: [ ^ self ].
	
	submode = #solid ifTrue: [ ^ self solidModelFor: engine ].
	submode = #wire ifTrue: [ ^ self wireModelFor: engine ].
	submode = #textured ifTrue: [ ^ self texturedModelFor: engine ].
	^ self texturedModelFor: engine
]

{ #category : #'extra per object rendering data' }
WTGSRenderingModels >> performGpuStateUpdateFor: engine frameIndex: frameIndex into: renderableSceneData [
	
]

{ #category : #'as yet unclassified' }
WTGSRenderingModels >> playModeCopyWith: copyDictionary [
	^ WTGSMesh new mesh: self bestModel
]

{ #category : #adding }
WTGSRenderingModels >> removedFromScene: scene [
	"Nothing needed here."
]

{ #category : #rendering }
WTGSRenderingModels >> renderModificationCountFor: mode submode: submode [
	^ (self modelForSubMode: submode) renderModificationCountFor: mode submode: submode
]

{ #category : #rendering }
WTGSRenderingModels >> renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [ 
	| model |
	
	model := self modelForSubMode: stateTracker submode.
	model renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex 
]

{ #category : #rendering }
WTGSRenderingModels >> renderOn: listBuilder mode: renderMode submode: submode instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [ 
	| model |
	
	model := self modelForSubMode: submode.
	model renderOn: listBuilder mode: renderMode submode: #full instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex 
]

{ #category : #rendering }
WTGSRenderingModels >> solidModelFor: anEngine [
	(solidModelBuilder isNil or: [ solidModelBuilder engine ~= anEngine ]) ifTrue: [
		invalidSolidModel := true.
		self createSolidModelBuilderFor: anEngine.
	].

	invalidSolidModel ifFalse: [ ^ solidModel ].
	^ self createSolidModel
]

{ #category : #rendering }
WTGSRenderingModels >> texturedModelFor: anEngine [
	(texturedModelBuilder isNil or: [ texturedModelBuilder engine ~= anEngine ]) ifTrue: [
		invalidTexturedModel := true.
		self createTexturedModelBuilderFor: anEngine.
	].

	invalidTexturedModel ifFalse: [ ^ texturedModel ].
	^ self createTexturedModel
]

{ #category : #rendering }
WTGSRenderingModels >> wireModelFor: anEngine [
	(wireModelBuilder isNil or: [ wireModelBuilder engine ~= anEngine ]) ifTrue: [
		invalidWireModel := true.
		self createWireModelBuilderFor: anEngine.
	].

	invalidWireModel ifFalse: [ ^ wireModel ].
	^ self createWireModel
]
