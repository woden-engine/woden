Class {
	#name : #WDEBoxVisualComponent,
	#superclass : #WDEVisualComponent3D,
	#instVars : [
		'box',
		'color'
	],
	#category : #'WodenEngine-Editor-Model'
}

{ #category : #visiting }
WDEBoxVisualComponent >> accept: visitor [
	^ visitor visitBoxVisualComponent: self
]

{ #category : #accessing }
WDEBoxVisualComponent >> boundingBox [
	^ box
]

{ #category : #accessing }
WDEBoxVisualComponent >> box [
	^ box
]

{ #category : #accessing }
WDEBoxVisualComponent >> box: anObject [
	box := anObject
]

{ #category : #accessing }
WDEBoxVisualComponent >> color [
	^ color
]

{ #category : #accessing }
WDEBoxVisualComponent >> color: anObject [
	color := anObject
]

{ #category : #initialization }
WDEBoxVisualComponent >> initialize [
	super initialize.
	color := Float32x4 ones.
	box := BoxF32 unitBox.
]
