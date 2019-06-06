from __future__ import print_function

fin=open("STR1_2","rb")
fin.seek(0x760)
charset=fin.read(0x3f).decode('ascii')
fin.seek(0xf68)
data=fin.read(0x80)
commands=["", "NORTH", "SOUTH", "EAST", "WEST",
			 "UP",    "DOWN",  "JUMP", "CLIM TREE",
			 "SHOO ROBO", "GO AIRL", "PICK LOCK",
			 "PULL LEVE", "PUSH RED", "PUSH WHIT",
			 "PUSH BLAC", "UNLO DOOR"]
objects= ["", "PARA", "FUEL", "LASE", "LOCK",
			 "KEY", "SUIT", "CRYS"]
			 
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
messages=[""]
print('{"messages":{')
for x in data:
	comma=","
	if ord(x) == 0xff:
		if num == 46:
			comma=""
		print(' "{}":"{}"{}'.format(num,message.strip().replace("  "," "),comma))
		messages.append(message.strip().replace("  "," "))
		message=""
		num+=1
		continue
	elif (ord(x) & 0x80):
		message += dict[(ord(x) & 0x3f) - 1]
	elif ord(x) & 0x3f == 0x3f:
		message += " "		
	else:		
		char=ord(x) & 0x3f
		message += charset[char]
		#if char == 0x3e:
			# add an extra space for full stops
			#message += " "
	if (ord(x) & 0x40):
		message += " "

print('},')
print('"characters":{')
# Character data
fin.seek(0x800)
data=fin.read(255)
charptr=224
while charptr < 256:
	charstring=""
	charstring='"{}":['.format(charptr)
	comma=","
	for i in range(0, 8):
		charstring += '{}'.format(ord(data[(charptr-224)+i]))
		if i < 7:
			charstring += ','
	if charptr==255:
		comma=""
	print('{}]{}'.format(charstring,comma))
	charptr+=1
print('},')
print('"pictures:":{')
# Colour data
fin.seek(0x7a0)
colourdata=fin.read(0x5c)
# Graphics data
fin.seek(0x19c0)
data=fin.read(0x123d)
image=1
colourptr=0
imageptr=0
colournames=["black", "red", "green", "yellow", "blue", "magenta", "cyan", "white"]
while imageptr < 0x123d:
	# first colour data
	image += 1
	colourptr+=1
	colourstring='"{}":{{"colours":{{'.format(image)
	colours=[]
	first=True
	while ord(colourdata[colourptr]) != 0xff:
		colour=(ord(colourdata[colourptr]) & 0xc0) >> 6
		if first == False:
			colourstring+=','
		first=False
		colourstring+='"{}":"{}"'.format(colour, colournames[ord(colourdata[colourptr]) & 0x0f])
		colourptr+=1
		if image == 19:
			# skip the duplicate
			colourptr+=1
			break
	# Now image data
	colourstring+="},"
	print(colourstring)
	colourptr+=1
	datastring='"data":"'
	commandnames={"0":"DRAW", "2":"MOVE", "5":"FILL", "7": "TEXT"}
	while ord(data[imageptr]) != 0xff:
		command=ord(data[imageptr])
		if (command & 0x20):
			datastring+='COLOUR {}; '.format((command & 0xc0) >> 6)
		command=command & 0x7
		datastring+='{} '.format(commandnames.get(str(command)), "DRAW")
		if commandnames.get(str(command)) == None:
			print ("Error: offset {} command {}".format(0x19c0 + imageptr, command))
		if command == 5:
			datastring += '; '
			imageptr+=1
		elif command == 7:
			datastring += '{}; '.format(ord(data[imageptr+1]))
			imageptr+=2
		else:
			datastring += '{}, {}; '.format(ord(data[imageptr+1])*4,ord(data[imageptr+2])*4)
			imageptr+=3
	imageptr+=1
	comma=","
	if imageptr == 0x123d:
		comma=""
	print('{}"}}{}'.format(datastring,comma))
print('},"roomcommands":[')
fin.seek(0x0000)
data=fin.read(0x2d4)
locptr=1
ptr=0
while ptr < 0x2d4:
	room=ord(data[ptr])
	image=ord(data[ptr+1])
	flags=ord(data[ptr+3])
	ptr += 4
	sentence='{{"location":{},"message":"{} ({})","image":{},"flags":{},"actions":['.format(locptr,room,messages[room],image,flags)
	locptr+=1
	while ord(data[ptr]) != 0xff:
		comma=","
		iftest=verbbit=ifbit=""
		if ord(data[ptr]) & 0x80:
			# command
			iftest="NOTINV"
			if ord(data[ptr]) & 0x60: 
				iftest="INROOM"
			elif ord(data[ptr]) & 0x20: 
				iftest="INROOM"
			elif ord(data[ptr]) & 0x40: 
				iftest="ININV"
			object=ord(data[ptr]) & 0x1f
			verb=ord(data[ptr+1])
			dest=ord(data[ptr+2])
			ptr+=3
		else:
			# direction
			verb=ord(data[ptr])
			dest=ord(data[ptr+1])
			ptr+=2
		if verb != 0:
			verbbit="IF VERB={} ".format(commands[verb])
		if iftest:
			ifbit="AND {}({}) ".format(iftest, objects[object])
		if ord(data[ptr]) == 0xff:
			comma=""
		sentence+='"{}{}GOTO {}"{}'.format(verbbit, ifbit, dest, comma)
	ptr+=1
	comma=","
	if ptr == 0x2d4:
		comma=""
	print("{}]}}{}".format(sentence,comma))
print("]}")
	
			
			
	

