Class {
	#name : #WDPhyDebugDrawingRenderable,
	#superclass : #WDCRenderable,
	#instVars : [
		'physicsWorld',
		'mutex',
		'isDebugMeshValid',
		'engine',
		'meshBuilder',
		'meshMaterial',
		'debugRenderable'
	],
	#category : #'WodenEngine-Physics-Interface'
}

{ #category : #'extra per object rendering data' }
WDPhyDebugDrawingRenderable >> createSceneDependentDataFor: engine into: objectStateBindings [
	^ nil
]

{ #category : #accessing }
WDPhyDebugDrawingRenderable >> engine [
	^ engine
]

{ #category : #accessing }
WDPhyDebugDrawingRenderable >> engine: anEngine [
	engine := anEngine
]

{ #category : #initialization }
WDPhyDebugDrawingRenderable >> initialize [
	super initialize.
	mutex := Semaphore forMutualExclusion.
	isDebugMeshValid := false.
]

{ #category : #scrolling }
WDPhyDebugDrawingRenderable >> invalidate [
	mutex critical: [ 
		isDebugMeshValid := false.
	]
]

{ #category : #accessing }
WDPhyDebugDrawingRenderable >> meshBuilder [
	meshBuilder ifNotNil: [
		meshBuilder
			clear;
			currentMaterial: meshMaterial.
		^ meshBuilder
	].

	meshMaterial := engine resourceCache loadMaterial: 'materials/basic/flat-xray.json'.
	meshBuilder := WDCDynamicGenericMeshBuilder for: engine.
	meshBuilder currentMaterial: meshMaterial.
	^ meshBuilder
]

{ #category : #accessing }
WDPhyDebugDrawingRenderable >> physicsWorld [
	^ physicsWorld
]

{ #category : #accessing }
WDPhyDebugDrawingRenderable >> physicsWorld: anObject [
	physicsWorld := anObject
]

{ #category : #rendering }
WDPhyDebugDrawingRenderable >> renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [ 
	self validateDebugMesh.
	debugRenderable renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex 
]

{ #category : #rendering }
WDPhyDebugDrawingRenderable >> renderOn: listBuilder mode: renderMode submode: submode instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [ 
	self validateDebugMesh.
	debugRenderable renderOn: listBuilder mode: renderMode submode: submode instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex
]

{ #category : #'as yet unclassified' }
WDPhyDebugDrawingRenderable >> validateDebugMesh [
	| builder |
	mutex critical: [
		isDebugMeshValid ifTrue: [ ^ self ].
		builder := self meshBuilder.
		physicsWorld debugDrawOnDynamicMesh: builder.
		debugRenderable := builder mesh
	]
]
