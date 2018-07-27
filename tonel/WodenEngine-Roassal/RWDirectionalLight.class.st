Class {
	#name : #RWDirectionalLight,
	#superclass : #RWLight,
	#category : 'WodenEngine-Roassal-Core'
}

{ #category : #initialization }
RWDirectionalLight >> createSceneNode [
	^ WDSGLightSource new directional
]
