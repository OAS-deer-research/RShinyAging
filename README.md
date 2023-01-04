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
 


