#README DOCUMENTATION#

to run R APP either run it in programming environment (I used Pycharm)

or use the following command

R -e "shiny::runApp('~/shinyapp')"   


The python files are separated as:


requestData.py <---pulls data from CDC website

csv_to_json.py <--- converts csv to json for upload to mongoDB

pymongoSetup.py <---sets up our collections and uploads our json files

driver.py< ---this was supposed to be a all in one driver code. IT does everything but run the R shiny App. Do not use it.

#################RECOMMENDATIONS FOR RUNNING THIS CODE AND CURRENT ISSUES#############################

The flow for correctly running this code is as follows:

1.) run requestData.py
2.) run csv_to_json.py
3.) run pymongoSetup.py 
4.) run visualizer.R *ITS RECOMMENDED YOU ONLY RUN THIS UNLESS YOU WANT TO TEST THE OTHER FILES


ISSUES WITH THIS SETUP

1.) IF THERE IS ANY DATA ALREADY IN THE DETERMINED COLLECTION WHEN YOU RUN FILES 1-3 IT WILL NOT OVERWRITE THE DATA ON MONGODB,
    IT WILL JUST ADD TO THE COLLECTION, MEANING QUERIED DATA IS GETTING DUPLICATED AND GIVING INCORRECT RESULTS. 

	*THIS MEANS THAT CURRENTLY IF YOU NEED TO UPDATE THE DATA ON MONGODB YOU HAVE TO DELETE THE COLLECTIONS ON MONGODB FIRST
	*I COULD NOT FIND A FIX FOR THIS


 
    

