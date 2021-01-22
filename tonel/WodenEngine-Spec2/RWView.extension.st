Extension { #name : #RWView }

{ #category : #'*WodenEngine-Spec2' }
RWView >> inspectionView [
	"This is the most basic presentation showing the state of the object"
	<inspectorPresentationOrder: 0 title: 'Woden Roassal View'>

	^ super inspectionView
]

{ #category : #'*WodenEngine-Spec2' }
RWView >> inspectionViewContext: aContext [
	super inspectionViewContext: aContext
]
