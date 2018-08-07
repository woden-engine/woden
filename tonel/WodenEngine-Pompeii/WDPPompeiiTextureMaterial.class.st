Class {
	#name : #WDPPompeiiTextureMaterial,
	#superclass : #PompeiiTextureMaterial,
	#instVars : [
		'driver',
		'modified',
		'shaderBinding'
	],
	#pools : [
		'AGPUConstants'
	],
	#category : #'WodenEngine-Pompeii-Material'
}

{ #category : #initialization }
WDPPompeiiTextureMaterial >> initialize [
	super initialize.
	modified := true
]

{ #category : #initialization }
WDPPompeiiTextureMaterial >> modified [
	modified := true
]
