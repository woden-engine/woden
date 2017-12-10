accessing
string
	^ self token: ($" asParser ,
		(($\ asParser, #any asParser) / $" asParser negate) star, 
		$" asParser
	)
	