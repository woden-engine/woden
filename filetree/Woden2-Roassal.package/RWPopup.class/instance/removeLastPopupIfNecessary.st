utility
removeLastPopupIfNecessary
	^ LastPopup notNil
		ifTrue: [ 
			LastPopup delete.
			LastPopup := nil ]