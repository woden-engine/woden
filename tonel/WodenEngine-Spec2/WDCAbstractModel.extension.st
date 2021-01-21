Extension { #name : #WDCAbstractModel }

{ #category : #'*WodenEngine-Spec2' }
WDCAbstractModel >> inspectionViewer [
	"This is the most basic presentation showing the state of the object"
	<inspectorPresentationOrder: 0 title: '3D Model View'>

	^ SpWodenViewPresenter new
		wodenApplication: self createViewer;
		yourself
]
