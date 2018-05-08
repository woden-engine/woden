Class {
	#name : #RWLight,
	#superclass : #RWElement,
	#category : 'WodenEngine-Roassal-Core'
}

{ #category : #accessing }
RWLight >> castShadows [
	^ sceneNode castShadows
]

{ #category : #accessing }
RWLight >> castShadows: aBoolean [
	self flag: 'Support shadows.'.
	sceneNode castShadows: aBoolean
]

{ #category : #accessing }
RWLight >> color [
	^ sceneNode state intensity
]

{ #category : #accessing }
RWLight >> color: aColor [
	sceneNode state intensity: aColor asWMVector4F
]

{ #category : #accessing }
RWLight >> diffuse [
	^ self color
]

{ #category : #accessing }
RWLight >> influenceRadius [
	^ sceneNode state radius
]

{ #category : #accessing }
RWLight >> influenceRadius: aNumber [
	sceneNode state radius: aNumber asFloat
]

{ #category : #'ray casting' }
RWLight >> rayCast: ray [
	^ nil -> nil
]

{ #category : #accessing }
RWLight >> specular [
	^ self color
]
