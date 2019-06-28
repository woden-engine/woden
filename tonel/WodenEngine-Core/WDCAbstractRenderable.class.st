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
		'isOpaqueShadowCaster'
	],
	#classVars : [
		'RenderPriorityDefault',
		'RenderPriorityEditorOpaqueAfter',
		'RenderPriorityEditorOpaqueBefore',
		'RenderPriorityEditorTranslucentAfter',
		'RenderPriorityEditorTranslucentSortedAfter',
		'RenderPriorityOpaque',
		'RenderPriorityOpaqueStatic',
		'RenderPriorityTranslucent',
		'RenderPriorityTranslucentSorted'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #'class initialization' }
WDCAbstractRenderable class >> initialize [
	RenderPriorityEditorOpaqueBefore := 0.

	RenderPriorityOpaque := 200.
	RenderPriorityOpaqueStatic := RenderPriorityOpaque.
	RenderPriorityDefault := RenderPriorityOpaque.

	RenderPriorityEditorOpaqueAfter := 800.
	
	RenderPriorityTranslucent := 1000.
	
	RenderPriorityEditorTranslucentAfter := 1500.

	RenderPriorityTranslucentSorted := 2000.
	
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

{ #category : #'extra per object rendering data' }
WDCAbstractRenderable >> createSceneDependentDataFor: engine into: bindings [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDCAbstractRenderable >> engine: newEngine [
]

{ #category : #initialization }
WDCAbstractRenderable >> initialize [
	super initialize.
	renderPriority := RenderPriorityDefault.
	boundingBox := WMBox3DF empty.
	isOpaqueShadowCaster := true.
]

{ #category : #'as yet unclassified' }
WDCAbstractRenderable >> invalidate [
	"This is the place for invalidating dynamic renderables."
]

{ #category : #accessing }
WDCAbstractRenderable >> isOpaqueShadowCaster [
	^ isOpaqueShadowCaster
]

{ #category : #accessing }
WDCAbstractRenderable >> isOpaqueShadowCaster: anObject [
	isOpaqueShadowCaster := anObject
]

{ #category : #accessing }
WDCAbstractRenderable >> name [
	^ name
]

{ #category : #accessing }
WDCAbstractRenderable >> name: anObject [
	name := anObject
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

{ #category : #accessing }
WDCAbstractRenderable >> translucentRenderPriority [
	self renderPriority: RenderPriorityTranslucent
]

{ #category : #accessing }
WDCAbstractRenderable >> translucentSortedRenderPriority [
	self renderPriority: RenderPriorityTranslucentSorted
]

{ #category : #'as yet unclassified' }
WDCAbstractRenderable >> validateForNode: aNode [
	"This is the place for validating dynamic renderables."
]
