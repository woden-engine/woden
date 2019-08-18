Class {
	#name : #WDCWaterRenderableMesh,
	#superclass : #WDCSurfaceDeformationRenderableMesh,
	#category : #'WodenEngine-Core-Mesh'
}

{ #category : #converting }
WDCWaterRenderableMesh >> asWaterRenderable [
	^ self
]

{ #category : #accessing }
WDCWaterRenderableMesh >> createDeformationState [
	^ WDCWaterMeshDeformationState new
		engine: engine;
		clipMapPeriod: clipMapPeriod;
		yourself
]

{ #category : #initialization }
WDCWaterRenderableMesh >> initialize [
	super initialize.
	self makeTranslucentSorted;
		renderPriority: RenderPriorityTranslucentSortedFirst
]
