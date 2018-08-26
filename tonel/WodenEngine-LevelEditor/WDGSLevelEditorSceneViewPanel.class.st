Class {
	#name : #WDGSLevelEditorSceneViewPanel,
	#superclass : #WDGSLevelEditorViewComponent,
	#instVars : [
		'view',
		'virtualWindow'
	],
	#category : #'WodenEngine-LevelEditor-View'
}

{ #category : #accessing }
WDGSLevelEditorSceneViewPanel >> boundsChanged [
	super boundsChanged.
	virtualWindow ifNotNil: [ virtualWindow extent: self extent asIntegerPoint ].
	self changed.
]

{ #category : #drawing }
WDGSLevelEditorSceneViewPanel >> buildMeshContentOn: meshBuilder [
	super buildMeshContentOn: meshBuilder.
	virtualWindow ifNotNil: [
		meshBuilder fill
			texture: virtualWindow validResolveRenderTarget currentFramebuffer colorAttachments first rectangle: self localBounds
	]
]

{ #category : #'as yet unclassified' }
WDGSLevelEditorSceneViewPanel >> createSceneView [
	view := WDASceneView engine: self engine model: self model.
	virtualWindow := view openInVirtualWindow.
	virtualWindow extent: self extent asIntegerPoint.
	self editor addSubView: view.
]
