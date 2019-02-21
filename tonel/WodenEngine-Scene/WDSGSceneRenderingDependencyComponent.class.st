Class {
	#name : #WDSGSceneRenderingDependencyComponent,
	#superclass : #Object,
	#traits : 'TWDCRenderingDependencyGraphNode',
	#classTraits : 'TWDCRenderingDependencyGraphNode classTrait',
	#instVars : [
		'scene'
	],
	#category : #'WodenEngine-Scene-Rendering'
}

{ #category : #'instance creation' }
WDSGSceneRenderingDependencyComponent class >> for: aScene [
	^ self new scene: aScene
]

{ #category : #accessing }
WDSGSceneRenderingDependencyComponent >> scene [
	^ scene
]

{ #category : #accessing }
WDSGSceneRenderingDependencyComponent >> scene: anObject [
	scene := anObject
]
