installing
installOn: aView
	| el |
	el := (RTLabel new text: (self label)) element.
	el @ RTHighlightable.
	aView add: el.
	
	el when: TRMouseClick do: [ :evt |
		aView clean.
		self openOn: aView.
		aView canvas camera focusOnCenter.
	].
