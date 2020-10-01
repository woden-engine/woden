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
	^ sceneNode intensity
]

{ #category : #accessing }
RWLight >> color: aColor [
	sceneNode intensity: aColor asFloat32x4
]

{ #category : #accessing }
RWLight >> diffuse [
	^ self color
]

{ #category : #accessing }
RWLight >> influenceRadius [
	^ sceneNode radius
]

{ #category : #accessing }
RWLight >> influenceRadius: aNumber [
	sceneNode radius: aNumber asFloat
]

{ #category : #'ray casting' }
RWLight >> rayCast: ray [
	^ nil -> nil
]

{ #category : #accessing }
RWLight >> specular [
	^ self color
]
