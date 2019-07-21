Class {
	#name : #WDGSRenderingModels,
	#superclass : #WDGSComponent,
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
	#category : #'WodenEngine-OldGameSystem-Level'
}

{ #category : #'as yet unclassified' }
WDGSRenderingModels class >> fuelIgnoredInstanceVariableNames [
	^ #('invalidWireModel' 'invalidSolidModel' 'invalidTexturedModel' 'wireModelBuilder' 'wireModel' 'wireModelMaterial' 'solidModelBuilder' 'solidModel' 'solidModelMaterial' 'texturedModelBuilder' 'texturedModel')
]

{ #category : #adding }
WDGSRenderingModels >> addedToEntity: anEntity [
	super addedToEntity: anEntity.
	anEntity ensureSpatialObject.
	self addedToScene: anEntity scene.
]

{ #category : #adding }
WDGSRenderingModels >> addedToScene: scene [
	| nodeComponent |
	scene ifNil: [ ^ self ].
	nodeComponent := entity sceneNodeComponent.
	nodeComponent node renderable: self
]

{ #category : #'as yet unclassified' }
WDGSRenderingModels >> bestModel [
	entity scene ifNil: [
		self halt.
	].

	^ self texturedModelFor: entity scene engine
]

{ #category : #accessing }
WDGSRenderingModels >> bucket [
	^ #renderingModels
]

{ #category : #rendering }
WDGSRenderingModels >> createSolidModel [
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
WDGSRenderingModels >> createSolidModelBuilderFor: anEngine [
	solidModelBuilder := WDCDynamicGenericMeshBuilder for: anEngine.
	solidModelMaterial := anEngine resourceCache loadMaterial: 'materials/basic/white.json'.
]

{ #category : #rendering }
WDGSRenderingModels >> createTexturedModel [
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
WDGSRenderingModels >> createTexturedModelBuilderFor: anEngine [
	texturedModelBuilder := WDCDynamicGenericMeshBuilder for: anEngine.
]

{ #category : #rendering }
WDGSRenderingModels >> createWireModel [
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
WDGSRenderingModels >> createWireModelBuilderFor: anEngine [
	wireModelBuilder := WDCDynamicGenericMeshBuilder for: anEngine.
	wireModelMaterial := anEngine resourceCache loadMaterial: 'materials/basic/flat.json'.
]

{ #category : #serialization }
WDGSRenderingModels >> fuelAfterMaterialization [
	self invalidate
]

{ #category : #initialization }
WDGSRenderingModels >> initialize [
	self invalidate
]

{ #category : #rendering }
WDGSRenderingModels >> invalidate [
	invalidWireModel := true.
	invalidSolidModel := true.
	invalidTexturedModel := true.
]

{ #category : #rendering }
WDGSRenderingModels >> invalidateTexturedModel [
	invalidTexturedModel := true.
]

{ #category : #'as yet unclassified' }
WDGSRenderingModels >> isSingleton [
	^ true
]

{ #category : #'as yet unclassified' }
WDGSRenderingModels >> isUsedInPlayMode [
	^ false
]

{ #category : #rendering }
WDGSRenderingModels >> modelForSubMode: submode [
	| engine |
	engine := entity scene engine.
	engine ifNil: [ ^ self ].
	
	submode = #solid ifTrue: [ ^ self solidModelFor: engine ].
	submode = #wire ifTrue: [ ^ self wireModelFor: engine ].
	submode = #textured ifTrue: [ ^ self texturedModelFor: engine ].
	^ self texturedModelFor: engine
]

{ #category : #'extra per object rendering data' }
WDGSRenderingModels >> performCommonGpuStateUpdateFor: engine frameIndex: frameIndex into: renderableSceneData [
	
]

{ #category : #'as yet unclassified' }
WDGSRenderingModels >> playModeCopyWith: copyDictionary [
	^ WDGSMesh new mesh: self bestModel
]

{ #category : #adding }
WDGSRenderingModels >> removedFromScene: scene [
	"Nothing needed here."
]

{ #category : #rendering }
WDGSRenderingModels >> renderModificationCountFor: mode submode: submode [
	^ (self modelForSubMode: submode) renderModificationCountFor: mode submode: submode
]

{ #category : #rendering }
WDGSRenderingModels >> renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [ 
	| model |
	
	model := self modelForSubMode: stateTracker submode.
	model renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex 
]

{ #category : #rendering }
WDGSRenderingModels >> solidModelFor: anEngine [
	(solidModelBuilder isNil or: [ solidModelBuilder engine ~= anEngine ]) ifTrue: [
		invalidSolidModel := true.
		self createSolidModelBuilderFor: anEngine.
	].

	invalidSolidModel ifFalse: [ ^ solidModel ].
	^ self createSolidModel
]

{ #category : #rendering }
WDGSRenderingModels >> texturedModelFor: anEngine [
	(texturedModelBuilder isNil or: [ texturedModelBuilder engine ~= anEngine ]) ifTrue: [
		invalidTexturedModel := true.
		self createTexturedModelBuilderFor: anEngine.
	].

	invalidTexturedModel ifFalse: [ ^ texturedModel ].
	^ self createTexturedModel
]

{ #category : #rendering }
WDGSRenderingModels >> wireModelFor: anEngine [
	(wireModelBuilder isNil or: [ wireModelBuilder engine ~= anEngine ]) ifTrue: [
		invalidWireModel := true.
		self createWireModelBuilderFor: anEngine.
	].

	invalidWireModel ifFalse: [ ^ wireModel ].
	^ self createWireModel
]
