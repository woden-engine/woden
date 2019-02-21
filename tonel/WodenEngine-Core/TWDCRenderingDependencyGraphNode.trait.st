Trait {
	#name : #TWDCRenderingDependencyGraphNode,
	#category : #'WodenEngine-Core-Rendering'
}

{ #category : #'rendering graph' }
TWDCRenderingDependencyGraphNode >> addRenderingElementsToGraph: graph [
]

{ #category : #'rendering process stages' }
TWDCRenderingDependencyGraphNode >> commitSurfaces [
]

{ #category : #'rendering process stages' }
TWDCRenderingDependencyGraphNode >> constructRenderingCommandLists [
]

{ #category : #'rendering process stages' }
TWDCRenderingDependencyGraphNode >> prepareRendering [
]

{ #category : #'rendering graph' }
TWDCRenderingDependencyGraphNode >> renderingGraphDependencies [
	^ #()
]

{ #category : #'rendering process stages' }
TWDCRenderingDependencyGraphNode >> sendRenderingCommands [
]
