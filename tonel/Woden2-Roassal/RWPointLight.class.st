Class {
	#name : #RWPointLight,
	#superclass : #RWLight,
	#category : 'Woden2-Roassal-Core'
}

{ #category : #initialization }
RWPointLight >> createSceneNode [
	^ WTSLightSource new point
]
