# RShinyAging
shiny app for biologists to enter aging data

Notes for next year:    

- Brandon Rochefort asked if there will be an option to filter/search by harvest year in the future. It might be nice to have a plot at the bottom of the Data Review tab that shows sample sizes by year for observer, processor, or DMU.    
- Request that DeerID uses 01, 02, 03, etc. for first 9 numbers so that the order stays the same when looking at upload and master data.  
- Have a tab where the datasheet can be downloaded (not sure if that is possible) and includes instructions on the cell dropdowns (and not sure if the download would need to be excel [because of the cell constraints] then saved as a csv) and screenshots if need be.  
- Folks are still not using the drop down cell values. Is there a way to have an auto-correct or auto-fill happen when they start typing? Or should we get rid of the drop downs and have more errors for them to correct?    
- There should no commas in the csv file. One person had commas in the Comments column which caused the deerid number to be recycled in the comments column. Another person had a comma in a processor name (Kewaskum Foods, LLC) and the app wouldn't upload the data.  
- Angela Lemminger emailed that the numbers in the review tab did not look correct. The master db indicated the data was uploaded multiple times and showed multiple versions of the DeerID which wouldn't have been caught as duplicates. For example, there were cases of DeerID = "CotterJasonCotterJason100" and "CotterJasonCotterJasonCotterJason100". So they uploaded the downloaded error file at least twice. She uploaded again because she added new data, but how did she number these new DeerIDs?   
- The file naming convention that people are using sucks. When folks would email with app questions, I would receive data files that were named "Copy of Data Entry Template_erros (1).csv" or "Copy of Data Entry Template_Newcsv3.xlsx".  
- Folks may have been using the template but weren't using the drop down box? For example, there were folks that had spelling errors in the county name and trailing white space in county names.  
- The upload can take a long time if there is a lot of data in the upload file and/or the database. Add a message indicated there will be a check appear once the master db has been updated with their data...so the save button isn't hit multiple times causing multiple uploades and taking longer.  
- Angela Lemminger data was taking a long time to submit...so long that the app would disconnect from the server. There was a lot of data in the db at that point.
- The review tabs can take a long time if there is a lot of data in the database.
- Remove white space from cells...especially county names (folks just see the spelling is correct and don't know how to check for white space) and people names (so there aren't multiple DeerIDs being created?).   
- How do we record deer aging data if the zone is not recorded? Isabella Eagen had data from split counties where the hunter did not fill out the aging card correctly; there were sections left blank so it is unknown if it was Monroe Farm or Forest, etc. Izzy is getting a DMU error for these records so she can't save to the database. Is there any way to salvage these records? Do we still want to record them somehow? If so, then how? Is it the same processor that has a lot of these cases with missing data (yes, Leroy's)?  
- If we send a template next year, explain that ages showing as a date will be corrected in the app to show correctly.  
- disconnect prior to upload...fix so that once we reach critical load of data we remove chunk so it runs faster (still need master file for review tab)! Set it up so this happens at midnight when no one using app.  
- Is there something with teh shinyio settings that can be changed to prevent disconnecting from the server (https://shiny.rstudio.com/articles/scaling-and-tuning.html)?  
- Is the disconnecting from server related to the shiny package version that is being used? The app didn't seem to run when it was the latest version so it uses 1.4.0 but one reference indicated version >= 1.4.7 (https://shiny.rstudio.com/articles/reconnecting.html).  
- add note about using the same name for all their data (Jed Hopp and Jedd Hopp; Emma Hanson and Emma Hansen)  
- consider asking to ID processors that are agers (at least 2 cases of processors, not DNR staff, aging deer) by including note in data entry comment   
- make sure DMUs are spelled as 'St Croix' and 'Fond du Lac' to match gis files

ISSUES WITH APP AFTER LOOKING AT DATA IN AGING REPO:  

- County drop down should have 'Fond du Lac' and 'St Croix' so it matches gis file spellings.  
- App was allowing errant ages (not producing an error) and including some that should have been corrected by app. Folks had ages: 1, 1-Jan, 2-Jan, 3, 3-Jan, '4 5', '6 8', 8-Jun  
- App data showed 2 variations of legal spike spelling (Legalspikes and LegalSpikes)  
- There were DeerIDs and DMUs in the comment column. I thought that was happening because of commas and we corrected that, but apparently not. This made checking the comments more tedious.   
- Folks are submitting deer from car killed deer (at least they noted it in the comments)  
- The app allowed a male yearling with unknown antler characteristics...should that happen?  
- There are spelling variations happening for Name and Processor. Make a note in app instructions? Have app show the different factor levels so they correct it before submission?  



