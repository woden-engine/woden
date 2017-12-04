code generation
writeCreateHandleCodeOn: out
	out tab tab << '"' << name << '"'; cr.
	out tab tab << 'beginBindingBank: ' << maxBindings << ';'; cr.
	elements do: [ :el | el writeCreateHandleCodeOn: out ].
	out cr