import re
import port_width as gp

filename = 'ddr3_top.v'
dutFile = open(filename).read()
modulename = re.search(r'module\s*(\w+)\s*' , dutFile).group(1)
newFileName = modulename + '_tb.v'
paraDict,inDict,outDict,ioDict = gp.getIoPort(filename)
widthDict = {}

#module name
tbFile = open(newFileName,'w')
tbFile.write('`timescale 1ns/1ps\n')
tbFile.write('module '+modulename+'_tb(\n')
tbFile.write(');\n\n')

# claim wire and reg
tbFile.write('////wire and reg\n')
for input in inDict.keys():
    if inDict[input] == None:
        tbFile.write('\treg\t\t'+input+';\n')
        widthDict[input] = 1
    else:
        tbFile.write('\treg\t['+inDict[input]+']\t'+input+';\n')
        widthDict[input] = gp.getWidth(paraDict,inDict[input])

for output in outDict.keys():
    if outDict[output] == None:
        tbFile.write('\twire\t\t'+output+';\n')
        widthDict[output] = 1
    else:
        tbFile.write('\twire\t['+outDict[output]+']\t'+output+';\n')
        widthDict[output] = gp.getWidth(paraDict,outDict[output])

for inout in ioDict.keys():
    if ioDict[inout] == None:
        tbFile.write('\treg\t'+inout+';\n')
        widthDict[inout] = 1
    else:
        tbFile.write('\treg\t['+ioDict[inout]+']\t'+inout+';\n')
        widthDict[inout] = gp.getWidth(paraDict,ioDict[inout])

tbFile.write('\n\n')


#initial assignment
tbFile.write('////initial assignment\n')
tbFile.write('initial begin\n')
for input in inDict.keys():
    if inDict[input] == None:
        tbFile.write('\t'+input+' <= 1\'b0;\n')
    else:
        tbFile.write('\t'+input+' <= '+str(widthDict[input])+'\'b0'+';\n')
tbFile.write('end\n\n')



#connector
tbFile.write('\n\n'+modulename+'\t'+modulename+'_1 #(\n')

for parameter in paraDict.keys():
    tbFile.write('\tparameter\t'+parameter+' = '+str(paraDict[parameter])+',\n')

tbFile.write(')(\n')


for input in inDict.keys():
        tbFile.write('\t.'+input+'('+input+'),\n')

for output in outDict.keys():
        tbFile.write('\t.'+output+'('+output+'),\n')


for inout in ioDict.keys():
        tbFile.write('\t.'+inout+'('+inout+'),\n')

tbFile.write(');\n')


tbFile.write('endmodule\n')
tbFile.close



