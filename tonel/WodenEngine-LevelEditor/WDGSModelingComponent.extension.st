Extension { #name : #WDGSModelingComponent }

{ #category : #'*WodenEngine-LevelEditor' }
WDGSModelingComponent >> asNodeModelForLevelEditor: editor [
	^ WDGSLevelEditorModelingComponentModel new component: self
]
