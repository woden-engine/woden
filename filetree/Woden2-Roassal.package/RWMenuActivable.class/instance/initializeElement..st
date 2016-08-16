hooks
initializeElement: element

	| menuActivable |
	(element hasInteraction: self class) ifFalse: [ ^ self initializeFirstTimeElement: element ].
	
	menuActivable := element getInteractionForClass: self class.
	actions do: [ :assoc |
		menuActivable item: assoc key action: assoc value ]