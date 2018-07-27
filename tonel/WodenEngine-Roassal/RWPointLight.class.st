Class {
	#name : #RWPointLight,
	#superclass : #RWLight,
	#category : 'WodenEngine-Roassal-Core'
}

{ #category : #initialization }
RWPointLight >> createSceneNode [
	^ WDSGLightSource new point
]
