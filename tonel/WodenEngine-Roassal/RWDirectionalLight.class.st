Class {
	#name : #RWDirectionalLight,
	#superclass : #RWLight,
	#category : 'WodenEngine-Roassal-Core'
}

{ #category : #visiting }
RWDirectionalLight >> accept: aVisitor [
	^ aVisitor visitDirectionalLight: self
]

{ #category : #initialization }
RWDirectionalLight >> createSceneNode [
	^ WDSGLightSource new directional
]
