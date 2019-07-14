Class {
	#name : #WDESStaticRenderableSceneNodeComponent,
	#superclass : #WDESAbstractSceneNodeComponent,
	#instVars : [
		'renderable'
	],
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #accessing }
WDESStaticRenderableSceneNodeComponent >> renderable [
	^ renderable
]

{ #category : #accessing }
WDESStaticRenderableSceneNodeComponent >> renderable: anObject [
	renderable := anObject
]
