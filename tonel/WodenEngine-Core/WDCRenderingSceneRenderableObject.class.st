Class {
	#name : #WDCRenderingSceneRenderableObject,
	#superclass : #WDCAbstractRenderingSceneObject,
	#instVars : [
		'renderable'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Rendering'
}

{ #category : #accessing }
WDCRenderingSceneRenderableObject >> renderOn: stateTracker [
	spatialObject renderRenderable: renderable with: stateTracker

]

{ #category : #accessing }
WDCRenderingSceneRenderableObject >> renderPriority [
	^ renderable renderPriority
]

{ #category : #accessing }
WDCRenderingSceneRenderableObject >> renderable [
	^ renderable
]

{ #category : #accessing }
WDCRenderingSceneRenderableObject >> renderable: anObject [
	renderable := anObject
]
