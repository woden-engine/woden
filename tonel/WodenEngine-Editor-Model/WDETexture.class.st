Class {
	#name : #WDETexture,
	#superclass : #WDELevelElement,
	#instVars : [
		'textureIndex',
		'isColorTexture',
		'path'
	],
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #accessing }
WDETexture >> isColorTexture [

	^ isColorTexture
]

{ #category : #accessing }
WDETexture >> isColorTexture: anObject [

	isColorTexture := anObject
]

{ #category : #accessing }
WDETexture >> path [

	^ path
]

{ #category : #accessing }
WDETexture >> path: anObject [

	path := anObject
]

{ #category : #accessing }
WDETexture >> textureIndex [

	^ textureIndex
]

{ #category : #accessing }
WDETexture >> textureIndex: anObject [

	textureIndex := anObject
]
