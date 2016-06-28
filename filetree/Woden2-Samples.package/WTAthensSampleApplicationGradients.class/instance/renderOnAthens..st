as yet unclassified
renderOnAthens: surface
	| paint path |
	surface drawDuring: [:can |
		surface clear: Color gray.
	
		path := can createPath: [:pb |
			pb 
				absolute;
				moveTo: 0@0;
				lineTo: 200@0;
				lineTo: 200@200;
				lineTo: 0@200;
				"moveTo: 0@0;
				curveVia: 50@0 and: 70@10 to: 80@20;
				curveVia: 70@50 and: 30@60 to: 0@60;
				curveVia: 20@40 and: 20@20 to: 0@0;
		
				moveTo: 40@30;
				lineTo: 50@30;
				lineTo: 50@40;
				lineTo: 40@40;"
				close
		].

		can pathTransform restoreAfter: [ 
			paint := surface 
				createLinearGradient: { 0->Color green . 0.5 -> Color red . 1->Color blue } 
				start: 50@50 
				stop: 150@150.
		
			can setPaint: paint.
			can paintOptions composeDefault.
			can drawShape: path.
		
			"can setStrokePaint: Color black.
			can drawShape: path."
		].

		can pathTransform restoreAfter: [ 
			can pathTransform translateX: 200 Y: 0.	

			paint := surface createRadialGradient: { 0->Color green . 0.5 -> Color red . 1->Color blue }
				center: 100@100 
				radius: 100
				focalPoint: 100@100.
		
			can setPaint: paint.
			can paintOptions composeDefault.
			can drawShape: path.
		
			"can setStrokePaint: Color black.
			can drawShape: path."
		].
	].
