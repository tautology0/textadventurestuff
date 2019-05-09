from __future__ import print_function

fin=open("STR1_2","rb")
fin.seek(0x760)
charset=fin.read(0x3f).decode('ascii')
fin.seek(0xf68)
data=fin.read(0x80)

entry=""
dict=[]
for x in data:
	if ord(x) == 0xff:
		dict.append(entry)
		entry=""
	elif ord(x) & 0x3f == 0x3f:
		entry += "\r\n"
	else:
		entry += charset[ord(x) & 0x3f]

fin.seek(0x900)
data=fin.read(0x668)

num=1
message=""
for x in data:
	if ord(x) == 0xff:
		print("{}: {}".format(num,message))
		message=""
		num+=1
		continue
	elif (ord(x) & 0x80):
		message += dict[(ord(x) & 0x3f) - 1]
	elif ord(x) & 0x3f == 0x3f:
		message += "\r\n"		
	else:		
		char=ord(x) & 0x3f
		message += charset[char]
		if char == 0x3e:
			# add an extra space for full stops
			message += " "
	if (ord(x) & 0x40):
		message += " "

	