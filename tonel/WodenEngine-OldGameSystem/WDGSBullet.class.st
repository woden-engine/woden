Class {
	#name : #WDGSBullet,
	#superclass : #Object,
	#instVars : [
		'node',
		'position',
		'velocity'
	],
	#category : #'WodenEngine-OldGameSystem-Player'
}

{ #category : #accessing }
WDGSBullet >> node [
	^ node
]

{ #category : #accessing }
WDGSBullet >> node: anObject [
	node := anObject
]

{ #category : #accessing }
WDGSBullet >> position [
	^ position
]

{ #category : #accessing }
WDGSBullet >> position: anObject [
	position := anObject
]

{ #category : #'as yet unclassified' }
WDGSBullet >> update: delta [
	velocity := velocity - (Float64x3 y: 9.8 * delta).
	position := position + (velocity * delta).
	
	node transform
		translation: position asFloat32x3.
	node stateChanged
]

{ #category : #accessing }
WDGSBullet >> velocity [
	^ velocity
]

{ #category : #accessing }
WDGSBullet >> velocity: anObject [
	velocity := anObject
]
