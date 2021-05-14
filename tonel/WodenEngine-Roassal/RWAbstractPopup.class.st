Class {
	#name : #RWAbstractPopup,
	#superclass : #RWElementInteraction,
	#category : #'WodenEngine-Roassal-Interaction'
}

{ #category : #hook }
RWAbstractPopup >> activeElement: anElement [
]

{ #category : #'as yet unclassified' }
RWAbstractPopup >> buildUISceneGraphWith: builder for: anElement in3DBillboard: in3DBillboard [
	^ builder null
]

{ #category : #initialization }
RWAbstractPopup >> initializeElement: anElement [
	| popupElement |
	popupElement := nil.
	anElement
		when: RWMouseEnter do: [ :evt |
			popupElement := anElement view createPopupAtViewPosition: evt position drawingWith: [ :builder |
				
				self
					activeElement: anElement;
					buildUISceneGraphWith: builder for: anElement in3DBillboard: false
			].
		];
		when: RWMouseMove do: [ :evt | popupElement view isInVirtualReality ifTrue: [popupElement position: evt position ]];
		when: RWMouseLeave do: [ :evt | popupElement remove ];
		when: RWTouch3DCursorEnter do: [ :evt |
			evt device displayUIWith: [ :builder |
				self
					activeElement: anElement;
					buildUISceneGraphWith: builder for: anElement in3DBillboard: true
			]
		]
]
