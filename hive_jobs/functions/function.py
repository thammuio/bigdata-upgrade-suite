import sys
for line in sys.stdin:
    (firstname,lastname)=line.split('\t')
    if len(firstname)>len(lastname):
        print "TRUE"