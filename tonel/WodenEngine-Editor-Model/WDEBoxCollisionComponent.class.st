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
	box := anObject.
	self changed.
]

{ #category : #initialization }
WDEBoxCollisionComponent >> initialize [
	super initialize.
	box := BoxF32 unitBox.
]

{ #category : #memento }
WDEBoxCollisionComponent >> restoreTransformStateMemento: memento [
	self box: memento
]

{ #category : #memento }
WDEBoxCollisionComponent >> transformStateMemento [
	^ self box
]
