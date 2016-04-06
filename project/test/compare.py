
def compare(list1, list2, lines, filename):
    try:
        len(list1) != len(list2)
    except ValueError:
        print('list length not equal')
    
    if lines is None:
        lines = len(list1)

    sameNum = 0
    for index in range(lines):
        if list1[index] == list2[index]:
            sameNum += 1

    similarity = sameNum / lines
    print('similarity ' + filename + ': %.3f%%\n' % (similarity * 100))
    return similarity

file0 = open('./target.txt', 'r')
file1 = open('./preds1.txt', 'r')
file2 = open('./preds2.txt', 'r')
file3 = open('./preds3.txt', 'r')
file4 = open('./preds4.txt', 'r')
file5 = open('./preds5.txt', 'r')
file6 = open('./preds6.txt', 'r')
file7 = open('./preds7.txt', 'r')
target = file0.readlines()
preds1 = file1.readlines()
preds2 = file2.readlines()
preds3 = file3.readlines()
preds4 = file4.readlines()
preds5 = file5.readlines()
preds6 = file6.readlines()
preds7 = file7.readlines()

compare(target, preds1, 200, 'preds1')
compare(target, preds2, 200, 'preds2')
compare(target, preds3, 200, 'preds3')
compare(target, preds4, 200, 'preds4')
compare(target, preds5, 200, 'preds5')
compare(target, preds6, 200, 'preds6')
compare(target, preds7, 200, 'preds7')

compare(preds5, preds7, 200, 'preds5&7')



