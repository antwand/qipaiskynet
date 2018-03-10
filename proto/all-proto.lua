local sprotoparser = require "sprotoparser"

local proto = {}

proto.c2s = sprotoparser.parse [[
.package {
	type 0 : integer
	session 1 : integer
}

handshake 1 {
	response {
		msg 0  : string
	}
}

get 2 {
	request {
		what 0 : string
	}
	response {
		result 0 : string
	}
}

set 3 {
	request {
		what 0 : string
		value 1 : string
	}
}

quit 4 {}

]]



proto.s2c = sprotoparser.parse [[
.package {
	type 0 : integer
	session 1 : integer
}

.test {
	.PropInfo{
		propid 0 : integer #
		propname 1 : string
	}
	.MyInfo {
		name 0 : string
		gold 1 : integer
		isvip 2 : boolean
		money 3 : integer(2)
		propids 4 : *integer
		propinfos 5 : *PropInfo(propid)
		pic_data 6 : binary
		boolarr 7 : *boolean
	}

heartbeat 1 {}
]]

return proto
