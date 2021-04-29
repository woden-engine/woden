Class {
	#name : #WDESSpotLightSourceSceneNodeComponent,
	#superclass : #WDESPointLightSourceSceneNodeComponent,
	#instVars : [
		'innerCutOffAngle',
		'outerCutOffAngle'
	],
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #accessing }
WDESSpotLightSourceSceneNodeComponent >> createSceneNode [
	^ super createSceneNode
		spot;
		innerSpotCutoff: innerCutOffAngle;
		outerSpotCutoff: outerCutOffAngle;
		yourself
]

{ #category : #initialization }
WDESSpotLightSourceSceneNodeComponent >> initialize [
	super initialize.
	innerCutOffAngle := 40.0.
	outerCutOffAngle := 40.0.
]

{ #category : #accessing }
WDESSpotLightSourceSceneNodeComponent >> innerCutOffAngle [

	^ innerCutOffAngle
]

{ #category : #accessing }
WDESSpotLightSourceSceneNodeComponent >> innerCutOffAngle: anObject [
	innerCutOffAngle := anObject.
	sceneNode ifNotNil: [ sceneNode innerSpotCutoff: innerCutOffAngle ].
]

{ #category : #accessing }
WDESSpotLightSourceSceneNodeComponent >> outerCutOffAngle [

	^ outerCutOffAngle
]

{ #category : #accessing }
WDESSpotLightSourceSceneNodeComponent >> outerCutOffAngle: anObject [
	outerCutOffAngle := anObject.
	sceneNode ifNotNil: [ sceneNode outerSpotCutoff: outerCutOffAngle ].
]
