Extension { #name : #WDELevelEditorSession }

{ #category : #'*WodenEngine-Editor-UI' }
WDELevelEditorSession >> openEditor [
	^ (WDELevelEditor on: self) openWithSpec
]
