Class {
	#name : #RWDirectionalLight,
	#superclass : #RWLight,
	#category : 'Woden2-Roassal-Core'
}

{ #category : #initialization }
RWDirectionalLight >> createSceneNode [
	^ WTSLightSource new directional
]
