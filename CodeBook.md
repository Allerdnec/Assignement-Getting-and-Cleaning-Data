# Getting and Cleaning Data Course Project

This CodeBook is meant to describe the work I have done for the assignement on the Getting and Cleaning Data on the coursera platform. The purpose of this project is to demonstrate my ability to collect, work with, and clean a data set, in other terms I need to create a tidy dataset.

## The project data

### Synopsis

One of the most exciting areas in all of data science right now is wearable computing. Companies like Fitbit, Nike, and Jawbone Up are racing to develop the most advanced algorithms to attract new users. The data linked to from the course website represent data collected from the accelerometers from the Samsung Galaxy S smartphone. A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

### Downloaded data

The data used was downloaded here:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip

The downloaded zip file contains:
* A README.txt file: describing the data and how to use the files
* A "activity\_labels.txt" file: describing the "activity names" for each "activity\_ID"
* A "features.txt" file: listing all the features names
* A "features\_infos.txt" file: explaining how the features were calculated
* A "test" folder containing the test dataset
* A "train" folder containing the training dataset
* The "train" and "test" folder contain each 3 txt files and 1 folder. The text files are the "subject\_ID" list (subject\_test.txt), the set of measurements (X.txt) and the set of label for the activities (Y.txt). The folder ("Inertial Signals") contains the original measures used to calculate the features and thus create the X.txt file.
c
### Used data

For this assignement all files were used except the ones contained in the "Inertial Signals" folder.

## The assignement

Every step of the work I have done is commented in the "run\_analysis.R" script. I divided my work in Tasks corresponding with the instructions on the coursera plateform. Within each tasks I numbered my steps. Below is a complete description of each of the steps. You can refer to the "run\_analysis.R" script to see the corresponding R code.
All the libraries I use are listed in the "run\_analysis.R" script.


### Task 1: Merge the training and the test sets to create one data set

I first load the common files for the test and training datasets ("features.txt" and "activity.txt" files) called respectively "features" and "activity\_labels" (step 1/) in my R code and then I renamed the variables(step 2/).
features:
* feature\_ID: the number of the feature
* feature\_name: the name of each feature

activity\_labels:
* activity\_ID: the number of the actvity
* activity\_name: the name of the activity

Then I first proceed with the test dataset as follow:
I read the files ("subject\_ID.txt", "X.txt", "Y.txt") contained in the test folder and save them in a list called "testlist" (step 3/). Now I have a list "testlist" containing three elements.

I rename the elements of the list to have meaningful names (step 4/):
"subject\_ID" (equals to the subject\_ID.txt file), 
"feature\_value" (equals to the X.txt file),
"activity\_ID" (equals to the Y.txt file).
Additionally, I also rename the elements in "feature\_value" with the "feature\_name" column from the "features" data table (made in step 2/)

I then merge all the elements of the list in order to obtain a data table named "test" (step 5/).

All the step are exactly the same  for the training set except I save it under "train". The variable names are also the same and processed in the same way (step 6/).

Next I do something extra because I want to keep track of the origin of my data before merging both tables. So I create a new variable called "data\_origin" in each table and fill it with "test" for the test table and with "train" for the train table (step 7/).

I then merge the table ("test" and "train") and save it under "test\_train" (step 8/).

In step 9/, I just want to test the data table to be sure I have merged everything correctly.

### Task 2: Extract mean and standard deviation (std)

In the step 1/ I rename all the variables in order to get the same names than in the table "features".

From the "features" data table I select only the "features\_name" containing the words "mean" or "std" using the function "filter()". I save the result in a table named "mean\_std\_features". Then I create a vector called meanstd in which I put the names of the variables I want to keep. (step /2)

In step 3/ I subset my data table "test\_train" with the meanstd vector, selecting this way only the columns I want to keep (e.g "subject\_ID", "activity\_ID" and the variables containing "mean" or "std")

Note that in this way I have all my variable correctly label (Task 4 is then already done).

### Task 3: Use descriptive activity names

In the step 1/ I use the "inner\_join()" function to match the "activity\_ID" with the "activity\_name" contained in the "activity\_labels" table (created in Task1, step 1/ and 2/).

In step 2/ I am just reorganising my columns in order to have the "subject\_ID" and "activity\_name" in position 1 and 2 respectively.

### Task 4: Label the data set descriptive variable

I have already take care of this in the Task 2, step 2/ and 3/.

### Task 5: Create the final table

Here, from the data set in step 4, I must create a second, independent tidy data set with the average of each variable for each activity and each subject.

To create the final table I do everything in one step using the pipeline operator (%>%).
I first use "group\_by()" to group my data by "activity\_name" and then by "subject\_ID". then I use the "summarize()" function to calculate the mean for each variable. I save the result in a new data table called "test\_train\_final".

Finally I use "write.table()" to write the data in a .txt file named "samsung\_testtrain.txt"
I also add a suggested line of code to read the data back into R.







