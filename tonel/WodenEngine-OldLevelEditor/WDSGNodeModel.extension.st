Extension { #name : #WDSGNodeModel }

{ #category : #'*WodenEngine-OldLevelEditor' }
WDSGNodeModel >> asNodeModelForLevelEditor: editor [
	^ self
]

{ #category : #'*WodenEngine-OldLevelEditor' }
WDSGNodeModel >> view: view dragControllerFor: anEvent [
	^ WDGSEDragMakeSelectionBox new
]

{ #category : #'*WodenEngine-OldLevelEditor' }
WDSGNodeModel >> view: view mouseOver: anEvent [
	view editor mouseOverNone
]
