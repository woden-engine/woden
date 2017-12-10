accessing
start
	^ super start ==> [ :tokens |
			WDIFBXNode new
			type: #'__Root__';
			children: tokens first;
			yourself
	]