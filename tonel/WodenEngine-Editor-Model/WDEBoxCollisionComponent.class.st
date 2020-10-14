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

{ #category : #serialization }
WDEBoxCollisionComponent >> encodeJsonKeyValues [
	^ super encodeJsonKeyValues , {
		#box . box encodeForJSON.
	}
]

{ #category : #initialization }
WDEBoxCollisionComponent >> initialize [
	super initialize.
	box := BoxF32 unitBox.
]

{ #category : #testing }
WDEBoxCollisionComponent >> isBoxCollisionComponent [
	^ true
]

{ #category : #serialization }
WDEBoxCollisionComponent >> loadFromJson: jsonData [
	super loadFromJson: jsonData.
	box := BoxF32 loadFromJson: (jsonData at: 'box').
]

{ #category : #memento }
WDEBoxCollisionComponent >> restoreTransformStateMemento: memento [
	self box: memento
]

{ #category : #memento }
WDEBoxCollisionComponent >> transformStateMemento [
	^ self box
]
