Class {
	#name : #WTGSBullet,
	#superclass : #Object,
	#instVars : [
		'node',
		'position',
		'velocity'
	],
	#category : 'WodenEngine-GameSystem-Player'
}

{ #category : #accessing }
WTGSBullet >> node [
	^ node
]

{ #category : #accessing }
WTGSBullet >> node: anObject [
	node := anObject
]

{ #category : #accessing }
WTGSBullet >> position [
	^ position
]

{ #category : #accessing }
WTGSBullet >> position: anObject [
	position := anObject
]

{ #category : #'as yet unclassified' }
WTGSBullet >> update: delta [
	velocity := velocity - (WMVector3D y: 9.8 * delta).
	position := position + (velocity * delta).
	
	node transform
		translation: position asWMVector3F.
	node stateChanged
]

{ #category : #accessing }
WTGSBullet >> velocity [
	^ velocity
]

{ #category : #accessing }
WTGSBullet >> velocity: anObject [
	velocity := anObject
]
