writing
writeCreateHandleCodeOn: out
	out tab tab tab << 'addBindingBankElement: ' << (ShaderBindingTypeMap at: type) << ' bindingPointCount: ' << count << '; "' << name << '"'; cr