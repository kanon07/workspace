import sys
file=open("checkresult.txt","w")
print(sys.argv[1])

for line in open(sys.argv[1], "r"):
    data = line.split()
    for line2 in open(sys.argv[1], "r"):
        data2 = line2.split()
        if float(data2[13]) > float(data[13]):
            print(line2)
            afnum = float(data2[0])-float(data[0])
            if float(data[13]) > afnum:
                file.write("1\n")
                break
            else:
                file.write("0\n")
                break
    #if flag == 1:
        #file.write("0\n")

print("finish!")
