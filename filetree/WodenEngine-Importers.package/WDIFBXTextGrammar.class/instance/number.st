accessing
number
	^ self token: ($+ asParser / $- asParser) optional , #digit asParser plus, 
		($. asParser, #digit asParser plus) optional,
		(($e asParser / $E asParser) , ($+ asParser / $- asParser) optional, #digit asParser plus) optional