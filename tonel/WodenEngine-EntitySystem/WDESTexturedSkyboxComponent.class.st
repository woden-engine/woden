Class {
	#name : #WDESTexturedSkyboxComponent,
	#superclass : #WDESBackgroundSceneNodeComponent,
	#instVars : [
		'texture',
		'lightingProbe',
		'renderable'
	],
	#category : #'WodenEngine-EntitySystem-Nodes'
}

{ #category : #accessing }
WDESTexturedSkyboxComponent >> addedToScene: scene [
	super addedToScene: scene.
	scene 
		lightingProbe: self validLightingProbe
]

{ #category : #'as yet unclassified' }
WDESTexturedSkyboxComponent >> createSkyBoxRenderableWithMaterial: skyMaterial [
	| meshBuilder |
	meshBuilder := WDCGenericMeshBuilder for: self engine.
	^ meshBuilder
		currentMaterial: skyMaterial;
		addInteriorCubeWithWidth: 2.0 height: 2.0 depth: 2.0;
		mesh
]

{ #category : #accessing }
WDESTexturedSkyboxComponent >> removedFromScene: scene [
	super removedFromScene: scene.
	scene lightingProbe: nil.
]

{ #category : #'as yet unclassified' }
WDESTexturedSkyboxComponent >> renderable [
	renderable ifNil: [ renderable := self createSkyBoxRenderableWithMaterial: ((WDCSkyMaterial for: self engine)
		skyTexture: texture;
		rgbm: true;
		yourself)].
	^ renderable 
]

{ #category : #accessing }
WDESTexturedSkyboxComponent >> texture [
	^ texture
]

{ #category : #accessing }
WDESTexturedSkyboxComponent >> texture: anObject [
	texture := anObject
]

{ #category : #'as yet unclassified' }
WDESTexturedSkyboxComponent >> validLightingProbe [
	lightingProbe ifNil: [ lightingProbe := self engine resourceCache computeEnvironmentLightProbeFromCubeTexture: texture ].
	^ lightingProbe
]
