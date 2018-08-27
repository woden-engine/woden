Extension { #name : #WDSGNodeModel }

{ #category : #'*WodenEngine-LevelEditor' }
WDSGNodeModel >> asNodeModelForLevelEditor: editor [
	^ self
]

{ #category : #'*WodenEngine-LevelEditor' }
WDSGNodeModel >> view: view dragControllerFor: anEvent [
	^ WDGSEDragMakeSelectionBox new
]

{ #category : #'*WodenEngine-LevelEditor' }
WDSGNodeModel >> view: view mouseOver: anEvent [
	view editor mouseOverNone
]
