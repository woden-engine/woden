Class {
	#name : #WDAESUniverseSimulationModel,
	#superclass : #WDAESAbstractUniverseModel,
	#category : #'WodenEngine-EntitySystem-Application'
}

{ #category : #'as yet unclassified' }
WDAESUniverseSimulationModel >> defaultViewClass [
	^ WDAESPlayerView 
]

{ #category : #initialization }
WDAESUniverseSimulationModel >> initializePhysicsWorld [
	physicsWorld := WDPhyPhysicsEngine current createDynamicsWorld.
	physicsWorld gravity: (WMVector3F x: 0.0 y: -9.8 z: 0.0).
	
	physicsWorldDebugDrawingSceneNode := WDSGSpatialObject new.
	physicsWorldDebugDrawingSceneNode
		visible: false;
		renderable: (WDPhyDebugDrawingRenderable new
			makeTranslucentSorted
			engine: self engine;
			physicsWorld: physicsWorld).
	scene addForeground: physicsWorldDebugDrawingSceneNode.


]

{ #category : #'rendering process stages' }
WDAESUniverseSimulationModel >> updateForFrameDelta: delta [
	super updateForFrameDelta: delta.
	universe tick: delta.
	physicsWorldDebugDrawingSceneNode renderable ifNotNil: #invalidate
]
