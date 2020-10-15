Class {
	#name : #WDEElementAnnouncement,
	#superclass : #Announcement,
	#instVars : [
		'element'
	],
	#category : #'WodenEngine-Editor-Model-Events'
}

{ #category : #accessing }
WDEElementAnnouncement >> element [
	^ element
]

{ #category : #accessing }
WDEElementAnnouncement >> element: anObject [
	element := anObject
]
