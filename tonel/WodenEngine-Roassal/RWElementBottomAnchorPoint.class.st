Class {
	#name : #RWElementBottomAnchorPoint,
	#superclass : #RWElementAnchorPoint,
	#category : #'WodenEngine-Roassal-Core'
}

{ #category : #accessing }
RWElementBottomAnchorPoint >> position [
	^ element position - (WMVector3F y: element height * 0.5)
]
