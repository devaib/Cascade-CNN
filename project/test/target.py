def lineGenerator(numLine):
    options = {'1': 'L', '2': 'D', '3': 'R', '4': 'C', '5': 'U', '6': 'O'}
    s = ''
    for i in range(numLine):
        num = input('#' + str(i) + ": 1-Left, 2-Down, 3-Right, 4-Close, 5-Up, 6-Open: ")
        append = str(i) +  ': ' + str(options[num]) + '\n'
        s += append
    return s

filename = input('Enter the filename: ')
f = open(filename, 'w')
lines = int(input('Enter the number of lines: '))
s = lineGenerator(lines)
f.write(s)
