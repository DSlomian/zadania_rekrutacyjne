def ListToString(inp):
    str1=""
    for i in inp:
        str1 += i
    return str1
x1 = "abcdefghijklmnoprstw"
k=[]
w=[]
z=[]
final=[]
a=len(x1)

for i in range(a):
    z=x1[i].upper()
    k.append(z)
for i in range(a):
    if i % 2 == 0:
        w.append(x1[i])
    else:
        w.append(k[i])

list1=ListToString(w)
list2=list1.swapcase()
final.append(list1)
final.append(list2)
print("Wyjściowy ciąg znaków x:",x1)
print("Lista wynikowa:",final)
