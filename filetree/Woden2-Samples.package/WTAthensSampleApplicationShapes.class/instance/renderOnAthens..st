rendering
renderOnAthens: surface
	| font path newRenderTime renderTime fps |
	newRenderTime := DateAndTime millisecondClockValue * 0.001.
	lastRenderTime ifNil: [ lastRenderTime := newRenderTime ].
	renderTime := newRenderTime - lastRenderTime.
	lastRenderTime := newRenderTime.
	(renderTime closeTo: 0.0) ifTrue: [ fps := 0.0 ] ifFalse: [ fps := 1.0 / renderTime ].
	font := engine fontCache default normal pointSize: 14.

	surface drawDuring: [:can |
		surface clear: Color white.
	
		path := can createPath: [:pb |
			pb
				absolute;
				moveTo: 0@0;
				curveVia: 50@0 and: 70@10 to: 80@20;
				curveVia: 70@50 and: 30@60 to: 0@60;
				curveVia: 20@40 and: 20@20 to: 0@0;
		
				moveTo: 40@30;
				lineTo: 50@30;
				lineTo: 50@40;
				lineTo: 40@40;
				close
		].
	
		can pathTransform restoreAfter: [ 
			can pathTransform translateX: 200 Y: 200.	
			can pathTransform scaleBy: 3.
		
			can setPaint: Color cyan.
			can paintOptions composeDefault.
			can drawShape: path.
		
			can setStrokePaint: Color black.
			can drawShape: path.
		].

		can pathTransform restoreAfter: [
			can pathTransform translateX: 200 Y: 200.	
			can pathTransform scaleBy: 2.5.

			can setPaint: Color green.
			can paintOptions composeDefault.
			can drawShape: path.

			can setStrokePaint: Color red.
			can drawShape: path.
		].

		"set font and color"
		can setFont: font.
		can setPaint: Color black.
		can pathTransform restoreAfter: [
			"can pathTransform translateX: 200 Y: 180."
			can pathTransform translateX: 10 Y: (font getPreciseAscent).
			can drawString: 'Hello Athens! ' , (fps printShowingDecimalPlaces: 3) , ' FPS'.
		]
	].