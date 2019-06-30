Class {
	#name : #WDCMutableRenderable,
	#superclass : #WDCAbstractRenderable,
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #copying }
WDCMutableRenderable >> copyForResourceCacheInstancing [
	^ self copy
]
