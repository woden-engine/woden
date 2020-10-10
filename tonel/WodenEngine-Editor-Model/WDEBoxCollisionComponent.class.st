Class {
	#name : #WDEBoxCollisionComponent,
	#superclass : #WDECollisionComponent3D,
	#instVars : [
		'box'
	],
	#category : #'WodenEngine-Editor-Model'
}

{ #category : #visiting }
WDEBoxCollisionComponent >> accept: visitor [
	^ visitor visitBoxCollisionComponent: self
]

{ #category : #accessing }
WDEBoxCollisionComponent >> box [
	^ box
]

{ #category : #accessing }
WDEBoxCollisionComponent >> box: anObject [
	box := anObject
]
