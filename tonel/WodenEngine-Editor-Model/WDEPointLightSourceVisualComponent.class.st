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

{ #category : #accessing }
WDEPointLightSourceVisualComponent >> buildLevelElementPropertyPageWith: builder [
	super buildLevelElementPropertyPageWith: builder.
	
	builder
		scalarPropertyNamed: 'Radius' selector: #radius min: 0.0
]

{ #category : #'as yet unclassified' }
WDEPointLightSourceVisualComponent >> createEntitySystemComponentWithTransform: componentTransform for: gameEntity [
	^ (super createEntitySystemComponentWithTransform: componentTransform for: gameEntity)
		radius: self radius;
		yourself
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

{ #category : #testing }
WDEPointLightSourceVisualComponent >> isPointLightSourceVisualComponent [
	^ true
]

{ #category : #serialization }
WDEPointLightSourceVisualComponent >> loadFromJson: jsonData context: context [
	super loadFromJson: jsonData context: context.
	radius := jsonData at: 'radius' ifAbsent: [radius].

]

{ #category : #'instance creation' }
WDEPointLightSourceVisualComponent >> newGameLightSourceComponent [
	^ WDESPointLightSourceSceneNodeComponent new
]

{ #category : #accessing }
WDEPointLightSourceVisualComponent >> radius [
	^ radius
]

{ #category : #accessing }
WDEPointLightSourceVisualComponent >> radius: anObject [
	radius := anObject.
	self changed.
]
