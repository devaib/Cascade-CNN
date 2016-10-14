# faceClassifier
Face Classifier using a cascade of CNNs

Files structure:

          ---faceClassifier
              ---demo                 simple demo for illustrating basic idea
              ---preprocess           convert weights from lua file to binary file
              ---src                  main program
              ---test                 test images
              ---weights              weights of each layer

###Run **main program**:

Step 1:
Open file "..../faceClassifier/src/model.c";

Step 2:
Modify the **FILE_PATH[]** to the path which your folder ***..../faceClassifier*** is on;

Step 3:
(optional) Change the test image path **TEST_IMAGE[]** (relative path);

Step 4:
make



###Run **demo**:

Step 1:
Open file "..../faceClassifier/demo/model.c";

Step 2:
Modify the **FILE_PATH[]** to the path which your folder ***..../faceClassifier*** is on;

Step 3:
(optional) Change the test image path **TEST_IMAGE[]** (relative path);

Step 4:
make
