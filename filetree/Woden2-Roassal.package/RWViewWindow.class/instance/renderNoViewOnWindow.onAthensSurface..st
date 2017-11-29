drawing
renderNoViewOnWindow: aWindow onAthensSurface: athensSurface
	| font |
	font := engine fontCache default normal pointSize: 14.
	
	athensSurface drawDuring: [:canvas |
		athensSurface clear: Color red.
		
		canvas setFont: font.
		canvas setPaint: (Color r: 0.0 g: 0.4 b: 0.0).
		
		canvas pathTransform restoreAfter: [
			canvas pathTransform translateX: 10 Y: (font getPreciseAscent).
			canvas drawString: 'ERROR: Roassal View Window without a view'.
		]
	]