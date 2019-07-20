Class {
	#name : #RWForceBasedLayoutOctTree,
	#superclass : #WDCOctTree,
	#category : #'WodenEngine-Roassal-Layout'
}

{ #category : #initialization }
RWForceBasedLayoutOctTree >> initialize [
	super initialize.
	nodeSplitCountThreshold := 1.
]

{ #category : #configuration }
RWForceBasedLayoutOctTree >> nodeClass [
	^ RWForceBasedLayoutOctTreeNode
]
