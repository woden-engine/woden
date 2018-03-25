Class {
	#name : #RWSpotLight,
	#superclass : #RWLight,
	#category : 'WodenEngine-Roassal-Core'
}

{ #category : #initialization }
RWSpotLight >> createSceneNode [
	^ WTSLightSource new spot
]
