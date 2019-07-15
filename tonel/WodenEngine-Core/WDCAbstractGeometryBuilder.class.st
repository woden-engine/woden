Class {
	#name : #WDCAbstractGeometryBuilder,
	#superclass : #Object,
	#instVars : [
		'collisionShapes'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #collisions }
WDCAbstractGeometryBuilder >> addBoxCollisionShape: box [
	self addCollisionShape: (self createAABoxCollisionShape: box)
]

{ #category : #collisions }
WDCAbstractGeometryBuilder >> addCollisionShape: aCollisionShape [
	collisionShapes add: aCollisionShape
]

{ #category : #collisions }
WDCAbstractGeometryBuilder >> addHeightMapCollision: heightMapTexture heightScale: heightScale scale: heightMapScale offset: heightMapOffset [
	self addCollisionShape: (self createHeightMapCollision: heightMapTexture heightScale: heightScale scale: heightMapScale offset: heightMapOffset)
]

{ #category : #accessing }
WDCAbstractGeometryBuilder >> clear [
	collisionShapes removeAll.
]

{ #category : #collisions }
WDCAbstractGeometryBuilder >> collisionShape [
	collisionShapes ifEmpty: [ ^ nil ].
	^ self createCompoundCollisionShape: collisionShapes
]

{ #category : #initialization }
WDCAbstractGeometryBuilder >> initialize [
	super initialize.
	collisionShapes := OrderedCollection new.
]
