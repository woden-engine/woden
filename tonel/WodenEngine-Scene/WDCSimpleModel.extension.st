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
