def main():

    try:
        f = open('students.txt', 'r')
    except OSError as e:
        print("File not found")
        quit()

    lines = f.readlines()

    # index for student lists:
    # 0 : lastName, 1 : FirstName, 2 : Grade, 3 : Classroom, 4 : Bus, 5 : GPA, 6 : TLast, 7 : TFirst
    students = []
    for line in lines:
        students.append(line.replace("\n", "").split(","))

    print("Please enter a choice following the format below:")
    print("S[tudent]: <lastname> [B[us]]")
    print("T[eacher]: <lastname>")
    print("B[us]: <number>")
    print("G[rade]: <number> [H[igh]|L[ow]]")
    print("A[verage]: <number>")
    print("I[nfo]")
    print("Q[uit]")

    val = input("").split(" ")

    while(1):
        # Quit
        if(val[0] == "Q" or val[0] == "Quit"):
            if(len(val) == 1):
                quit()
            else:
                print("Improper input, try again...")
                printPrompt()

        # S[tudent]: <lastname> [B[us]]
        elif(val[0] == "S:" or val[0] == "Student:"):
            if(len(val) == 2):

                for student in students:
                    if(student[0] == val[1]):
                        print("{}, {}, {}, {}, {}, {}".format(
                            student[0], student[1], student[2], student[3], student[6], student[7]))

            elif(len(val) == 3):
                if(val[2] == "B" or val[2] == "Bus"):

                    for student in students:
                        if(student[0] == val[1]):
                            print("{}, {}, {}".format(
                                student[0], student[1], student[4]))

                else:
                    print("Improper input, try again...")
                    printPrompt()
            else:
                print("Improper input, try again...")
                printPrompt()

        # T[eacher]: <lastname>
        elif(val[0] == "T:" or val[0] == "Teacher:"):
            if(len(val) == 2):

                for student in students:
                    if(student[6] == val[1]):
                        print("{}, {}".format(student[0], student[1]))
            else:
                print("Improper input, try again...")
                printPrompt()

        # B[us]: <number>
        elif(val[0] == "B:" or val[0] == "Bus:"):

            if(len(val) == 2):
                for student in students:
                    if(student[4] == val[1]):
                        print("{}, {}, {}, {}".format(
                            student[0], student[1], student[2], student[3]))
            else:
                print("Improper input, try again...")
                printPrompt()

        # G[rade]: <number> [H[igh]|L[ow]]
        elif(val[0] == "G:" or val[0] == "Grade:"):
            if(len(val) == 2):

                for student in students:
                    if(student[2] == val[1]):
                        print("{}, {}".format(student[0], student[1]))

            elif(len(val) == 3):
                if(val[2] == "L" or val[2] == "Low"):

                    lowList = []

                    lowestGPA = 100.00
                    for student in students:
                        if(student[2] == val[1]):
                            if(float(student[5]) < float(lowestGPA)):
                                lowList.clear()
                                lowList.append(student)
                                lowestGPA = student[5]
                            elif(float(student[5]) == float(lowestGPA)):
                                lowList.append(student)

                    for lowStudent in lowList:
                        print("{}, {}, {}, {}, {}, {}".format(
                            lowStudent[0], lowStudent[1], lowStudent[5], lowStudent[6], lowStudent[7], lowStudent[4]))

                elif(val[2] == "H" or val[2] == "High"):

                    highList = []

                    highestGPA = 0.0
                    for student in students:
                        if(student[2] == val[1]):
                            if(float(student[5]) > float(highestGPA)):
                                highList.clear()
                                highList.append(student)
                                highestGPA = student[5]
                            elif(float(student[5]) == float(highestGPA)):
                                highList.append(student)

                    for highStudent in highList:
                        print("{}, {}, {}, {}, {}, {}".format(
                            highStudent[0], highStudent[1], highStudent[5], highStudent[6], highStudent[7], highStudent[4]))

                else:
                    print("Improper input, try again...")
                    printPrompt()
            else:
                print("Improper input, try again...")
                printPrompt()

        # A[verage]: <number>
        elif(val[0] == "A:" or val[0] == "Average:"):
            if(len(val) == 2):

                count = 0.0
                tot = 0.0

                for student in students:
                    if(student[2] == val[1]):
                        count += 1
                        tot += float(student[5])

                print("{}, {:.2f}".format(val[1], tot/count))

            else:
                print("Improper input, try again...")
                printPrompt()

        # I[nfo]
        elif(val[0] == "I" or val[0] == "Info"):
            if(len(val) == 1):

                count = 0

                for i in range(7):
                    for student in students:
                        if(int(student[2]) == i):
                            count += 1
                    print("{}, {}".format(i, count))
                    count = 0

            else:
                print("Improper input, try again...")
                printPrompt()

        else:
            print("Improper input, try again...")
            printPrompt()

        val = input("").split(" ")


def printPrompt():
    print("Please enter a choice following the format below:")
    print("S[tudent]: <lastname> [B[us]]")
    print("T[eacher]: <lastname>")
    print("B[us]: <number>")
    print("G[rade]: <number> [H[igh]|L[ow]]")
    print("A[verage]: <number>")
    print("I[nfo]")
    print("Q[uit]")


if __name__ == "__main__":
    main()
