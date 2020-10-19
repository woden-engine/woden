Class {
	#name : #WDEPointLightSourceVisualComponent,
	#superclass : #WDELightSourceVisualComponent,
	#instVars : [
		'radius'
	],
	#category : #'WodenEngine-Editor-Model-Level'
}

{ #category : #visiting }
WDEPointLightSourceVisualComponent >> accept: visitor [
	^ visitor visitPointLightSourceVisualComponent: self
]

{ #category : #serialization }
WDEPointLightSourceVisualComponent >> encodeJsonKeyValues [
	^ super encodeJsonKeyValues , {
		#radius . radius.
	}
]

{ #category : #initialization }
WDEPointLightSourceVisualComponent >> initialize [
	super initialize.
	radius := 10.0.
]

{ #category : #serialization }
WDEPointLightSourceVisualComponent >> loadFromJson: jsonData [
	super loadFromJson: jsonData.
	radius := jsonData at: 'radius' ifAbsent: [radius].

]

{ #category : #accessing }
WDEPointLightSourceVisualComponent >> radius [
	^ radius
]

{ #category : #accessing }
WDEPointLightSourceVisualComponent >> radius: anObject [
	radius := anObject
]
