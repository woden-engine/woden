Class {
	#name : #WDESModelLibraryNodeInstanceComponent,
	#superclass : #WDESAbstractSceneNodeComponent,
	#instVars : [
		'modelLibraryName',
		'modelNodeName',
		'modelLibrary',
		'collisionShape'
	],
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #accessing }
WDESModelLibraryNodeInstanceComponent >> collisionShape [
	^ collisionShape
]

{ #category : #accessing }
WDESModelLibraryNodeInstanceComponent >> collisionShape: aCollisionShape [
	collisionShape := aCollisionShape
]

{ #category : #accessing }
WDESModelLibraryNodeInstanceComponent >> createSceneNode [
	^ self validModelLibrary instanceSceneNodeNamed: modelNodeName
]

{ #category : #'as yet unclassified' }
WDESModelLibraryNodeInstanceComponent >> ensureValidCollisionShape [
	collisionShape := (WDCAbstractGeometryBuilder new
		createAABoxCollisionShape: self validSceneNode localBoundingBox)
		asCollisionShape

]

{ #category : #accessing }
WDESModelLibraryNodeInstanceComponent >> modelLibraryName [
	^ modelLibraryName
]

{ #category : #accessing }
WDESModelLibraryNodeInstanceComponent >> modelLibraryName: anObject [
	modelLibraryName := anObject
]

{ #category : #accessing }
WDESModelLibraryNodeInstanceComponent >> modelNodeName [
	^ modelNodeName
]

{ #category : #accessing }
WDESModelLibraryNodeInstanceComponent >> modelNodeName: anObject [
	modelNodeName := anObject
]

{ #category : #accessing }
WDESModelLibraryNodeInstanceComponent >> validModelLibrary [
	modelLibrary ifNil: [ modelLibrary := self engine resourceCache load3DModel: modelLibraryName ].
	^ modelLibrary
]
