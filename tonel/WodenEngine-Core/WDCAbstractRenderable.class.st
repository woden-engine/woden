"
I represent an abstract renderable. An abstract renderable is an object that is rendered in a scene.
"
Class {
	#name : #WDCAbstractRenderable,
	#superclass : #Object,
	#instVars : [
		'name',
		'boundingBox',
		'renderPriority',
		'isOpaqueShadowCaster',
		'blendingMode',
		'depthWriteMask',
		'depthTestingEnabled',
		'subRenderMode'
	],
	#classVars : [
		'RenderPriorityDefault',
		'RenderPriorityEditorOpaqueAfter',
		'RenderPriorityEditorOpaqueBefore',
		'RenderPriorityEditorTranslucentAfter',
		'RenderPriorityEditorTranslucentSortedAfter',
		'RenderPriorityOpaque',
		'RenderPriorityOpaqueBackground',
		'RenderPriorityOpaqueStatic',
		'RenderPriorityTranslucent',
		'RenderPriorityTranslucentSorted',
		'RenderPriorityTranslucentSortedFirst',
		'RenderPriorityTranslucentSortedNormal'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #'class initialization' }
WDCAbstractRenderable class >> initialize [
	RenderPriorityEditorOpaqueBefore := 0.

	RenderPriorityOpaqueBackground := 100.

	RenderPriorityOpaque := 200.
	RenderPriorityOpaqueStatic := RenderPriorityOpaque.
	RenderPriorityDefault := RenderPriorityOpaque.

	RenderPriorityEditorOpaqueAfter := 800.
	
	RenderPriorityTranslucent := 1000.
	
	RenderPriorityEditorTranslucentAfter := 1500.

	RenderPriorityTranslucentSorted := 2000.

	RenderPriorityTranslucentSortedFirst := 2100.

	RenderPriorityTranslucentSortedNormal := 2300.
	
	RenderPriorityEditorTranslucentSortedAfter := 2500.
	
]

{ #category : #accessing }
WDCAbstractRenderable class >> renderPriorityDefault [
	^ RenderPriorityDefault
]

{ #category : #accessing }
WDCAbstractRenderable class >> renderPriorityEditorOpaqueAfter [
	^ RenderPriorityEditorOpaqueAfter
]

{ #category : #accessing }
WDCAbstractRenderable class >> renderPriorityEditorOpaqueBefore [
	^ RenderPriorityEditorOpaqueBefore
]

{ #category : #'class initialization' }
WDCAbstractRenderable class >> renderPriorityEditorTranslucentAfter [
	^ RenderPriorityEditorTranslucentAfter
]

{ #category : #accessing }
WDCAbstractRenderable class >> renderPriorityOpaque [
	^ RenderPriorityOpaque
]

{ #category : #accessing }
WDCAbstractRenderable class >> renderPriorityOpaqueBackground [
	^ RenderPriorityOpaqueBackground
]

{ #category : #accessing }
WDCAbstractRenderable class >> renderPriorityOpaqueStatic [
	^ RenderPriorityOpaqueStatic
]

{ #category : #accessing }
WDCAbstractRenderable class >> renderPriorityTranslucent [
	^ RenderPriorityTranslucent
]

{ #category : #accessing }
WDCAbstractRenderable class >> renderPriorityTranslucentSorted [
	^ RenderPriorityTranslucentSorted
]

{ #category : #accessing }
WDCAbstractRenderable class >> renderPriorityTranslucentSortedFirst [
	^ RenderPriorityTranslucentSortedFirst
]

{ #category : #accessing }
WDCAbstractRenderable class >> renderPriorityTranslucentSortedNormal [
	^ RenderPriorityTranslucentSortedNormal
]

{ #category : #converting }
WDCAbstractRenderable >> asTerrainRenderable [
	^ WDCTerrainRenderableMesh new
		mesh: self
]

{ #category : #converting }
WDCAbstractRenderable >> asWaterRenderable [
	^ WDCWaterRenderableMesh new
		mesh: self
]

{ #category : #accessing }
WDCAbstractRenderable >> backgroundRenderPriority [
	self renderPriority: RenderPriorityOpaqueBackground
]

{ #category : #accessing }
WDCAbstractRenderable >> blendingMode [
	^ blendingMode
]

{ #category : #accessing }
WDCAbstractRenderable >> blendingMode: anObject [
	blendingMode := anObject
]

{ #category : #accessing }
WDCAbstractRenderable >> boundingBox [
	^ boundingBox
]

{ #category : #accessing }
WDCAbstractRenderable >> boundingBox: anObject [
	boundingBox := anObject.
]

{ #category : #copying }
WDCAbstractRenderable >> copyForResourceCacheInstancing [
	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDCAbstractRenderable >> createRenderingRenderablesFor: spatialObject [
	^ { WDCRenderingSceneRenderableObject new
		spatialObject: spatialObject;
		renderable: self;
		yourself 
	}
]

{ #category : #accessing }
WDCAbstractRenderable >> depthTestingEnabled [
	^ depthTestingEnabled
]

{ #category : #accessing }
WDCAbstractRenderable >> depthTestingEnabled: anObject [
	depthTestingEnabled := anObject
]

{ #category : #accessing }
WDCAbstractRenderable >> depthWriteMask [
	^ depthWriteMask
]

{ #category : #accessing }
WDCAbstractRenderable >> depthWriteMask: anObject [
	depthWriteMask := anObject
]

{ #category : #'as yet unclassified' }
WDCAbstractRenderable >> engine: newEngine [
]

{ #category : #'as yet unclassified' }
WDCAbstractRenderable >> exportModelWith: exporter [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDCAbstractRenderable >> extractConvexCollisionShapesWithTransform: nodeGlobalTransform into: convexComponents [
	"By default, do nothing."
]

{ #category : #initialization }
WDCAbstractRenderable >> initialize [
	super initialize.
	renderPriority := RenderPriorityDefault.
	boundingBox := BoxF32 new.
	isOpaqueShadowCaster := true.
	depthWriteMask := nil.
	depthTestingEnabled := nil.
]

{ #category : #'as yet unclassified' }
WDCAbstractRenderable >> invalidate [
	"This is the place for invalidating dynamic renderables."
]

{ #category : #testing }
WDCAbstractRenderable >> isNullRenderable [
	^ false
]

{ #category : #accessing }
WDCAbstractRenderable >> isOpaqueShadowCaster [
	^ isOpaqueShadowCaster
]

{ #category : #accessing }
WDCAbstractRenderable >> isOpaqueShadowCaster: anObject [
	isOpaqueShadowCaster := anObject
]

{ #category : #testing }
WDCAbstractRenderable >> isSkinnedRenderable [
	^ false
]

{ #category : #accessing }
WDCAbstractRenderable >> makeBackgroundRenderable [
	self
		depthWriteMask: false;
		isOpaqueShadowCaster: false;
		backgroundRenderPriority
]

{ #category : #accessing }
WDCAbstractRenderable >> makeTranslucent [
	self
		depthWriteMask: false;
		isOpaqueShadowCaster: false;
		translucentRenderPriority
]

{ #category : #accessing }
WDCAbstractRenderable >> makeTranslucentSorted [
	self 
		depthWriteMask: false;
		isOpaqueShadowCaster: false;
		translucentSortedRenderPriority
]

{ #category : #accessing }
WDCAbstractRenderable >> name [
	^ name
]

{ #category : #accessing }
WDCAbstractRenderable >> name: anObject [
	name := anObject
]

{ #category : #enumerating }
WDCAbstractRenderable >> precacheResources [
]

{ #category : #rendering }
WDCAbstractRenderable >> renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [ 
	self subclassResponsibility
]

{ #category : #accessing }
WDCAbstractRenderable >> renderPriority [
	^ renderPriority
]

{ #category : #accessing }
WDCAbstractRenderable >> renderPriority: anObject [
	renderPriority := anObject
]

{ #category : #'as yet unclassified' }
WDCAbstractRenderable >> renderRenderPassDependenciesWith: stateTracker [
]

{ #category : #initialization }
WDCAbstractRenderable >> setFlatColorSubRenderMode [
	self subRenderMode: WDCStateTrackerSubRenderMode flatColor
]

{ #category : #initialization }
WDCAbstractRenderable >> setFlatTexturedSubRenderMode [
	self subRenderMode: WDCStateTrackerSubRenderMode flatTextured
]

{ #category : #initialization }
WDCAbstractRenderable >> setFullShadedSubRenderMode [
	self subRenderMode: WDCStateTrackerSubRenderMode fullShaded
]

{ #category : #initialization }
WDCAbstractRenderable >> setShadedColorSubRenderMode [
	self subRenderMode: WDCStateTrackerSubRenderMode shadedColor
]

{ #category : #rendering }
WDCAbstractRenderable >> setupObjectRenderingStatesOn: stateTracker [
	stateTracker
		objectDepthWriteMask: depthWriteMask;
		objectDepthEnabled: depthTestingEnabled;
		objectBlendingMode: blendingMode;
		objectSubMode: subRenderMode
]

{ #category : #accessing }
WDCAbstractRenderable >> subRenderMode [
	^ subRenderMode
]

{ #category : #accessing }
WDCAbstractRenderable >> subRenderMode: anObject [
	subRenderMode := anObject
]

{ #category : #accessing }
WDCAbstractRenderable >> translucentRenderPriority [
	self renderPriority: RenderPriorityTranslucent
]

{ #category : #accessing }
WDCAbstractRenderable >> translucentSortedRenderPriority [
	self renderPriority: RenderPriorityTranslucentSortedNormal
]

{ #category : #'renderable state' }
WDCAbstractRenderable >> updateCommonGpuStateForFrame: frameIndex [
]

{ #category : #'as yet unclassified' }
WDCAbstractRenderable >> validateForNode: aNode [
	"This is the place for validating dynamic renderables."
]
