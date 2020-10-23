Extension { #name : #WDCSimpleModel }

{ #category : #'*WodenEngine-Scene' }
WDCSimpleModel >> createViewer [
	| viewer |
	viewer := WDA3DModelViewerModel new.
	viewer newScene.
	viewer addMeshModel: (self meshFor: viewer engine).
	^ viewer
]
