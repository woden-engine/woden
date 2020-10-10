Class {
	#name : #WDERectangleCollisionComponent,
	#superclass : #WDECollisionComponent2D,
	#instVars : [
		'rectangle'
	],
	#category : #'WodenEngine-Editor-Model'
}

{ #category : #visiting }
WDERectangleCollisionComponent >> accept: visitor [
	^ visitor visitRectangleCollisionComponent: self
]

{ #category : #accessing }
WDERectangleCollisionComponent >> rectangle [
	^ rectangle
]

{ #category : #accessing }
WDERectangleCollisionComponent >> rectangle: anObject [
	rectangle := anObject
]
