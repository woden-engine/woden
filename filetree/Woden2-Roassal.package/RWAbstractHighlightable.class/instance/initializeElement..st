hooks
initializeElement: element
	element
		when: RWMouseEnter
		do: [ :e | 
			self doHighlight: element.
			e signalUpdate ].
	element
		when: RWMouseLeave
		do: [ :e | 
			self doUnhighlight: element.
			e signalUpdate ]