Extension { #name : #WDGSModelingComponent }

{ #category : #'*WodenEngine-OldLevelEditor' }
WDGSModelingComponent >> asNodeModelForLevelEditor: editor [
	^ WDGSLevelEditorModelingComponentModel new component: self
]
