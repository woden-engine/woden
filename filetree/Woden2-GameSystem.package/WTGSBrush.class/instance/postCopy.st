copying
postCopy
	super postCopy.
	positions := positions copy.
	faces := faces collect: #copy.
	faces do: [ :face | face addedToBrush: self].
