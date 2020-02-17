Class {
	#name : #WDASceneModel,
	#superclass : #WDAModel,
	#instVars : [
		'scene',
		'camera',
		'currentTime',
		'isInVirtualReality'
	],
	#category : #'WodenEngine-Scene-Application'
}

{ #category : #'rendering graph' }
WDASceneModel >> addRenderingElementsToGraph: renderingDependencyGraph [
	super addRenderingElementsToGraph: renderingDependencyGraph.
	scene ifNotNil: [ scene addRenderingElementsToGraph: renderingDependencyGraph ]
]

{ #category : #'as yet unclassified' }
WDASceneModel >> buildScene: aBlock [
	self newScene.
	aBlock cull: scene cull: camera
]

{ #category : #accessing }
WDASceneModel >> camera [
	^ camera
]

{ #category : #accessing }
WDASceneModel >> camera: anObject [
	camera := anObject
]

{ #category : #accessing }
WDASceneModel >> currentTime [
	^ currentTime
]

{ #category : #accessing }
WDASceneModel >> currentTime: anObject [
	currentTime := anObject
]

{ #category : #initialization }
WDASceneModel >> initialize [
	super initialize.
	currentTime := 0.0.
	isInVirtualReality := false.
]

{ #category : #accessing }
WDASceneModel >> isInVirtualReality [
	^ isInVirtualReality
]

{ #category : #accessing }
WDASceneModel >> isInVirtualReality: anObject [
	isInVirtualReality := anObject
]

{ #category : #'instance creation' }
WDASceneModel >> newScene [
	scene := WDSGScene for: engine.

	camera := WDSGCamera new.
	scene add: camera.
	^ scene
]

{ #category : #'as yet unclassified' }
WDASceneModel >> openInVR [
	^ self openWith: self defaultViewClass allowingVR
]

{ #category : #'rendering graph' }
WDASceneModel >> renderingGraphDependencies [
	^ super renderingGraphDependencies , (scene ifNil: [#()] ifNotNil: #modelRenderingGraphDependencies)
]

{ #category : #accessing }
WDASceneModel >> scene [
	^ scene
]

{ #category : #accessing }
WDASceneModel >> scene: anObject [
	scene := anObject
]

{ #category : #'rendering process stages' }
WDASceneModel >> updateForFrameDelta: delta [
	super updateForFrameDelta: delta.
	currentTime := currentTime + delta
]
