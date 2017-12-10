accessing
node
	^ super node ==> [ :tokens |
		WDIFBXNode new
			type: tokens first;
			attributes: tokens third;
			children: tokens fourth;
			yourself
	]