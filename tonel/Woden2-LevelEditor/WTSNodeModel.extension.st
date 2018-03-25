Extension { #name : #WTSNodeModel }

{ #category : #'*Woden2-LevelEditor' }
WTSNodeModel >> asNodeModelForLevelEditor: editor [
	^ self
]

{ #category : #'*Woden2-LevelEditor' }
WTSNodeModel >> view: view dragControllerFor: anEvent [
	^ WTGEDragMakeSelectionBox new
]

{ #category : #'*Woden2-LevelEditor' }
WTSNodeModel >> view: view mouseOver: anEvent [
	view editor mouseOverNone
]
