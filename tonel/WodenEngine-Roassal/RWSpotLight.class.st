Class {
	#name : #RWSpotLight,
	#superclass : #RWLight,
	#category : 'WodenEngine-Roassal-Core'
}

{ #category : #visiting }
RWSpotLight >> accept: aVisitor [
	^ aVisitor visitSpotLight: self
]

{ #category : #initialization }
RWSpotLight >> createSceneNode [
	^ WDSGLightSource new spot
]
