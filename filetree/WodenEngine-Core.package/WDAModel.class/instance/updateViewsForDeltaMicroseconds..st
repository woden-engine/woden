rendering process stages
updateViewsForDeltaMicroseconds: microsecondsDelta
	views do: [:v | v updateForDeltaMicroseconds: microsecondsDelta].