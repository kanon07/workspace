#TimeResol = 0.1
TimeResol = 1

TCPIP_HeaderSize = 52

lastTimeGr = nil
sumByte = nil
cntPack = nil

while line=gets do
#	print line
	tokens = line.split
	n_tok = tokens.length

	time = tokens[0]
	if time.match(/(\d\d):(\d\d):(\d\d)\.(\d+)/) then #04:19:38.967485
		h = $1.to_i
		m = $2.to_i
		s = $3.to_i
		ms = $4.to_i
		time = h*60*60 + m*60 + s + ms*0.000001
	end
	timeGr = (time.to_f/TimeResol).to_i*TimeResol
#	print time, "\n"

	if 2 <= n_tok  and  tokens[-2] == "length" then
		size = tokens[-1].to_i
	else
		size = 0
		$stderr.print "(?_?)", __LINE__, "\n"
		$stderr.print line
	end
	size += TCPIP_HeaderSize

	if lastTimeGr == timeGr then
		sumByte += size
		cntPack += 1
	else
		if lastTimeGr != nil then
			print "@\t", timeGr, "\t", sumByte, "\t", cntPack, "\n"
		end
		sumByte = size
		cntPack = 1
	end
	lastTimeGr = timeGr
	#print time, "\t", size, "\t"
	#print sumByte, "\t", cntPack, "\n"
end
