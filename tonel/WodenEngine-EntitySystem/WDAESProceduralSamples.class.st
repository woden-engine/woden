Class {
	#name : #WDAESProceduralSamples,
	#superclass : #Object,
	#category : #'WodenEngine-EntitySystem-Samples'
}

{ #category : #'as yet unclassified' }
WDAESProceduralSamples class >> example01SimpleLevel [
	| engine universe |
	engine := WDCEngine default.
	universe := WDESSimpleUniverse for: engine.
	universe buildSector: [ :sector |
		sector buildGenericMeshWith: [ :meshBuilder |
			meshBuilder
				translateToX: 0.0 y: -0.25 z: 0.0;
				addCubeWithWidth: 10.0 height: 0.5 depth: 10.0;
				addCollisionBox;
				
				translateToX: 0.0 y: 0.25 z: 0.0;
				addCubeWithWidth: 0.5 height: 0.5 depth: 0.5;
				addCollisionBox				
		].

		sector addPlayerStartPointAt: (WMVector3F x: 0.0 y: 2.0 z: 2.0)
	].

	universe createSimulationModel
		open
		spawnPlayer.

]

{ #category : #'see class side' }
WDAESProceduralSamples >> seeClassSide [
]
