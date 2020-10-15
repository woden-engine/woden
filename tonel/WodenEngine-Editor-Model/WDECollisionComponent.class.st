Class {
	#name : #WDECollisionComponent,
	#superclass : #WDEEntityComponent,
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #'as yet unclassified' }
WDECollisionComponent class >> box: box [
	^ WDEBoxCollisionComponent new
		box: box
		yourself
]

{ #category : #testing }
WDECollisionComponent class >> isAbstract [
	^ self == WDECollisionComponent
]

{ #category : #'as yet unclassified' }
WDECollisionComponent class >> rectangle: rectangle [
	^ WDERectangleCollisionComponent new
		rectangle: rectangle
		yourself
]

{ #category : #accessing }
WDECollisionComponent >> boundingBox [
	^ self subclassResponsibility
]

{ #category : #testing }
WDECollisionComponent >> isCollisionComponent [
	^ true
]
