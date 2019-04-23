Class {
	#name : #RWPointLight,
	#superclass : #RWLight,
	#category : 'WodenEngine-Roassal-Core'
}

{ #category : #visiting }
RWPointLight >> accept: aVisitor [
	^ aVisitor visitPointLight: self
]

{ #category : #initialization }
RWPointLight >> createSceneNode [
	^ WDSGLightSource new point
]
