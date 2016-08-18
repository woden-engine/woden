specs
defaultSpec
	<spec: #default>
	
	^ SpecLayout composed
		newColumn: [:mainColumn |
			mainColumn newRow: [ :row |
				row
					add: #xScaleLabel;
					add: #xScale;
					add: #xScaleMore;
					add: #xScaleLess.
			].

			mainColumn newRow: [ :row |
				row
					add: #yScaleLabel;
					add: #yScale;
					add: #yScaleMore;
					add: #yScaleLess.
			].

			mainColumn newRow: [ :row |
				row
					add: #xOffsetLabel;
					add: #xOffset;
					add: #xOffsetMore;
					add: #xOffsetLess.
			].

			mainColumn newRow: [ :row |
				row
					add: #yOffsetLabel;
					add: #yOffset;
					add: #yOffsetMore;
					add: #yOffsetLess.
			].

			mainColumn newRow: [ :row |
				row
					add: #rotationLabel;
					add: #rotation;
					add: #rotationMore;
					add: #rotationLess.
			].

		];
		yourself