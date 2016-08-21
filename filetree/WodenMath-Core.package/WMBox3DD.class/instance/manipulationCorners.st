accessing
manipulationCorners
	^ {
		self nearBottomLeft .
		self nearBottomRight .
		self nearTopLeft .
		self nearTopRight .
		
		self farBottomLeft .
		self farBottomRight .
		self farTopLeft .
		self farTopRight .

		self nearLeftPoint .
		self nearRightPoint .
		self nearTopPoint .
		self nearBottomPoint .
		
		self farLeftPoint .
		self farRightPoint .
		self farTopPoint .
		self farBottomPoint .

		self leftBottomPoint .		
		self rightBottomPoint .
		self leftTopPoint .
		self rightTopPoint .
		
		self leftPoint .
		self rightPoint .
		self bottomPoint .
		self topPoint .		
		self nearPoint .
		self farPoint .
		
		self center .
		
	 }