Class {
	#name : #WDSSceneRendererViewportLayer,
	#superclass : #Object,
	#instVars : [
		'visibleObjects',
		'lights'
	],
	#category : #'WodenEngine-Scene-Rendering'
}

{ #category : #adding }
WDSSceneRendererViewportLayer >> addLight: aLight [
	lights add: aLight
]

{ #category : #adding }
WDSSceneRendererViewportLayer >> addVisibleObject: aRenderingRenderable [
	visibleObjects add: aRenderingRenderable.
]

{ #category : #initialization }
WDSSceneRendererViewportLayer >> initialize [
	super initialize.
	visibleObjects := OrderedCollection new.
	lights := OrderedCollection new.
]

{ #category : #accessing }
WDSSceneRendererViewportLayer >> lights [
	^ lights
]

{ #category : #sorting }
WDSSceneRendererViewportLayer >> sortVisibleObjectsWithBlock: aBlock [
	visibleObjects sort: aBlock
]

{ #category : #accessing }
WDSSceneRendererViewportLayer >> visibleObjects [
	^ visibleObjects
]
