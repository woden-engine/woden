Extension { #name : #WDCSimpleModel }

{ #category : #'*WodenEngine-Scene' }
WDCSimpleModel >> createViewer [
	| viewer |
	viewer := WDA3DModelViewerModel new.
	viewer 
		modelAsset: self;
		newScene;
		addMeshModel: (self meshFor: viewer engine).
	^ viewer
]

{ #category : #'*WodenEngine-Scene' }
WDCSimpleModel >> instanceDefaultSceneNode [
	^ WDSGSpatialObject new
		renderable: (self meshFor: WDCEngine default);
		yourself
]
