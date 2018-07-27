Class {
	#name : #WDGSBullet,
	#superclass : #Object,
	#instVars : [
		'node',
		'position',
		'velocity'
	],
	#category : #'WodenEngine-GameSystem-Player'
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
	velocity := velocity - (WMVector3D y: 9.8 * delta).
	position := position + (velocity * delta).
	
	node transform
		translation: position asWMVector3F.
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
