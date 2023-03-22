import re

def getIoPort(filename):
    paraPattern = re.compile(r'\s*parameter\s+(\w+)\s*\=\s*(\d+)\s*,*')
    inputPattern = re.compile(r'\s*input\s*\[*((\w*)[\*|\-|\w*]*\:(\w*))*\]*\s*(\w+)\s*,?')
    outputPattern = re.compile(r'\s*output\s*\[*((\w*)[\*|\-|\w*]*\:(\w*))*\]*\s*(\w+)\s*,?')
    inoutPattern = re.compile(r'\s*inout\s*\[*((\w*)[\*|\-|\w*]*\:(\w*))*\]*\s*(\w+)\s*,?')
    moduleDone = re.compile(r'\)\;')
    paraDict = {}
    inDict = {}
    outDict = {}
    inoDict = {}
    moduleFile = open(filename)

    for eachLine in moduleFile.read().splitlines():
        pa =  paraPattern.search(eachLine)
        inp = inputPattern.search(eachLine)
        outp = outputPattern.search(eachLine)
        ino = inoutPattern.search(eachLine)
        done = moduleDone.match(eachLine)
        if done:
            break
        elif pa:
            # print(pa.group() ,' ',pa.group(1),' ',pa.group(2))  
            paraDict[pa.group(1)] = int(pa.group(2))
        elif inp:
            inDict[inp.group(4)] = inp.group(1)
            # print(inp.groups())
        elif outp:
            outDict[outp.group(4)] = outp.group(1)
            # print(outp.groups())

        elif ino:
            inoDict[ino.group(4)] = ino.group(1)
            # print(ino.groups())

    moduleFile.close()
    return paraDict,inDict,outDict,inoDict

def getWidth(num,text):
    tp = re.search(r'(\w+)(\*|\-)*(\w+)*(\*|\-)*(\w+)*\:(\w+)' , text)
    if tp:      
        # print(tp.groups())
        if num.get(tp.group(1)):
            a = num[tp.group(1)]
        elif tp.group(1) == None:
            a = 0
        else:
            a = int(tp.group(1))

        if num.get(tp.group(3)):
            b = num[tp.group(3)]
        elif tp.group(3) == None:
            b = 0
        else:
            b = int(tp.group(3))

        if num.get(tp.group(5)):
            c = num[tp.group(5)]
        elif tp.group(5) == None:
            c = 0
        else:
            c = int(tp.group(5))  

        res1 = a * b if tp.group(2) == '*' else a - b if tp.group(2) == '-' else a 
        res2 = res1 * c if tp.group(4) == '*' else res1 - c if tp.group(4) == '-' else res1 
        width = res2 - int(tp.group(6)) + 1
        return width
    else:
        return 'error'

# filename = 'ddr3_top.v'

# paraDict,inDict,outDict,inoDict = getIoPort(filename)

#print(moduleFile)



# for parameter in paraDict.keys():
#     print(parameter , '=' , paraDict[parameter])
# print('\ninput:')
# for input in inDict.keys():
#     if inDict[input] == None:
#         print(input , 'one bit')
#     else:
#         print(input , '[',inDict[input],']')

# print('\noutput:')
# for output in outDict.keys():
#     if outDict[output] == None:
#         print(output , 'one bit')
#     else:
#         print(output , '[',outDict[output],']')

# print('\ninout:')
# for inoput in inoDict.keys():
#     if inoDict[inoput] == None:
#         print(inoput , 'one bit')
#     else:
#         print(inoput , '[',inoDict[inoput],']')


