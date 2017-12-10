ignorables
singleLineComment
	^ $; asParser, newline negate star, newline