Class {
	#name : #RWElementTopAnchorPoint,
	#superclass : #RWElementAnchorPoint,
	#category : #'WodenEngine-Roassal-Core'
}

{ #category : #accessing }
RWElementTopAnchorPoint >> position [
	^ element transform transformPosition3: (WMVector3F y: element height * 0.5)
]
