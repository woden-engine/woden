Extension { #name : #AbstractFileReference }

{ #category : #'*WodenEngine-Spec2' }
AbstractFileReference >> inspection3DModelView [
	"This is the most basic presentation showing the state of the object"
	<inspectorPresentationOrder: -1 title: '3D Model View'>

	^ (WDCEngine default resourceCache load3DModel: self) inspectionViewer
]

{ #category : #'*WodenEngine-Spec2' }
AbstractFileReference >> inspection3DModelViewContext: aContext [ 
	
	aContext active: (WDCAbstractModelLoader loaderForExtension: self extension) isNotNil
]
