Class {
	#name : #RWForceBasedLayoutOctTreeNode,
	#superclass : #WDCOctTreeNode,
	#instVars : [
		'charge',
		'chargeCenter'
	],
	#category : #'WodenEngine-Roassal-Layout'
}

{ #category : #accessing }
RWForceBasedLayoutOctTreeNode >> charge [
	^ charge
]

{ #category : #accessing }
RWForceBasedLayoutOctTreeNode >> charge: anObject [
	charge := anObject
]

{ #category : #accessing }
RWForceBasedLayoutOctTreeNode >> chargeCenter [
	^ chargeCenter
]

{ #category : #accessing }
RWForceBasedLayoutOctTreeNode >> chargeCenter: anObject [
	chargeCenter := anObject
]
