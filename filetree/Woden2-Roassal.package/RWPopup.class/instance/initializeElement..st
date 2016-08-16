hooks
initializeElement: anElement
	anElement
		when: RWMouseEnter
		do: [ :evt | 
			self removeLastPopupIfNecessary.
			LastPopup := TextMorph new contentsAsIs: (self textFor: anElement).
			LastPopup color: Color red.
			LastPopup position: ActiveHand position.
			LastPopup openInWorld ].
	anElement when: RWMouseLeave do: [ :evt | self removeLastPopupIfNecessary ]