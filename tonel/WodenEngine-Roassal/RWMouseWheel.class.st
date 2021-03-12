Class {
	#name : #RWMouseWheel,
	#superclass : #RWMouseEvent,
	#instVars : [
		'scrollVertical',
		'scrollHorizontal'
	],
	#category : #'WodenEngine-Roassal-Events'
}

{ #category : #accessing }
RWMouseWheel >> scrollHorizontal [

	^ scrollHorizontal
]

{ #category : #accessing }
RWMouseWheel >> scrollHorizontal: anObject [

	scrollHorizontal := anObject
]

{ #category : #accessing }
RWMouseWheel >> scrollVertical [

	^ scrollVertical
]

{ #category : #accessing }
RWMouseWheel >> scrollVertical: anObject [

	scrollVertical := anObject
]
