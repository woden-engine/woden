"
I represent an abstract renderable. An abstract renderable is an object that is rendered in a scene.
"
Class {
	#name : #WDCRenderable,
	#superclass : #Object,
	#instVars : [
		'name',
		'boundingBox',
		'modificationCount',
		'renderingSceneDependantData'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #accessing }
WDCRenderable >> boundingBox [
	^ boundingBox
]

{ #category : #accessing }
WDCRenderable >> boundingBox: anObject [
	boundingBox := anObject.
	modificationCount := modificationCount + 1.
]

{ #category : #'extra per object rendering data' }
WDCRenderable >> createSceneDependentDataFor: engine into: bindings [
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDCRenderable >> engineChangedTo: newEngine [
]

{ #category : #initialization }
WDCRenderable >> initialize [
	super initialize.
	modificationCount := 0.
	boundingBox := WMBox3DF empty.
]

{ #category : #'as yet unclassified' }
WDCRenderable >> invalidate [
	"This is the place for invalidating dynamic renderables."
]

{ #category : #accessing }
WDCRenderable >> name [
	^ name
]

{ #category : #accessing }
WDCRenderable >> name: anObject [
	name := anObject
]

{ #category : #'extra per object rendering data' }
WDCRenderable >> performCommonGpuStateUpdateFor: engine frameIndex: frameIndex into: renderableSceneData [
]

{ #category : #'extra per object rendering data' }
WDCRenderable >> performGpuStateUpdateFor: engine frameIndex: frameIndex into: renderableSceneData [
]

{ #category : #accessing }
WDCRenderable >> renderModificationCountFor: mode submode: submode [
	^ modificationCount
]

{ #category : #rendering }
WDCRenderable >> renderOn: stateTracker instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [ 
	self subclassResponsibility
]

{ #category : #'as yet unclassified' }
WDCRenderable >> renderOn: listBuilder mode: renderMode submode: submode instanceCount: instanceCount baseInstance: baseInstance baseVertex: baseVertex [
	self subclassResponsibility
]

{ #category : #accessing }
WDCRenderable >> renderingSceneDependantData [
	^ renderingSceneDependantData
]

{ #category : #accessing }
WDCRenderable >> renderingSceneDependantData: anObject [
	renderingSceneDependantData := anObject
]

{ #category : #'as yet unclassified' }
WDCRenderable >> validateForNode: aNode [
	"This is the place for validating dynamic renderables."
]
