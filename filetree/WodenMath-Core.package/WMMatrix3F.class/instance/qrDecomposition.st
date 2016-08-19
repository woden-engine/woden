linear algebra
qrDecomposition
	<var: #(u1 u2 u3) type: #(WMVector3F object)>
	| u1 u2 u3 q r |
	u1 := self firstColumn normalized.

	u2 := self secondColumn.
	u2 := (u2 - (u1 * (u2 dot: u1))) normalized.

	u3 := self thirdColumn.
	u3 := u3 - (u1 * (u3 dot: u1)).
	u3 := (u3 - (u2 * (u3 dot: u2))) normalized.
	
	q := self class
		m11: u1 x m12: u2 x m13: u3 x
		m21: u1 y m22: u2 y m23: u3 y
		m31: u1 z m32: u2 z m33: u3 z.
		
	r := q transposed * self.
	^ { q . r }