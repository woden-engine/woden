Class {
	#name : #RWSpotLight,
	#superclass : #RWLight,
	#category : 'Woden2-Roassal-Core'
}

{ #category : #initialization }
RWSpotLight >> createSceneNode [
	^ WTSLightSource new spot
]
