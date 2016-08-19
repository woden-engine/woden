accessing
corners
	^ {
		self nearBottomLeft .
		self nearBottomRight .
		self nearTopLeft .
		self nearTopRight .
		
		self farBottomLeft .
		self farBottomRight .
		self farTopLeft .
		self farTopRight .
	 }