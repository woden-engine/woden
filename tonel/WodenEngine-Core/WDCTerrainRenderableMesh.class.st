Class {
	#name : #WDCTerrainRenderableMesh,
	#superclass : #WDCSurfaceDeformationRenderableMesh,
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #converting }
WDCTerrainRenderableMesh >> asTerrainRenderable [
	^ self
]

{ #category : #accessing }
WDCTerrainRenderableMesh >> createDeformationState [
	^ WDCTerrainMeshDeformationState new
		engine: engine;
		clipMapPeriod: clipMapPeriod;
		yourself
]
