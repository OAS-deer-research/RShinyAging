# Written by: Grace Freeman - WDNR-OAS
# Contact info: grace.freeman@wisconsin.gov

# Updated by: Beth Wojcik 
# Contact info: beth.wojcik@wisconsin.gov

# Purpose: Aging Data Entry
# App used for data entry, data cleaning, and data visualization for the 
# WDNR biologist staff

# Last updated: 10 October 2022
# Recent updates: Reverting to older version of shiny package to redeploy app with new contact phone number

# Reminders:
# 1) CSV must be formatting with appropriate columns - send template to biologists at start of the season but don't send excel template with formatting if possible and have DeerID start with 01,02,03, etc instead of 1,2,3
# 2) keep and eye on app usage esp during november - upgrade from free (25 hours in a cycle) to starter plan (100 hours in a cycle) is $9/month with recurring billing

# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above (or use code in console)
# and publish the app using the publish option to the right of the 'Run App' button above (or use code in console)
# 

###############################################################################
## NOTES FROM SWITCHING THE APP FROM GRACE'S SHINY ACCOUNT TO BETH'S
## When Beth switched Grace's app to new shiny account (Aug 2022), all files/folders in the wmcommons location that Grace had were copy and pasted into a version controlled R project on Beth's computer, then the "old" subfolder and example data csv files were deleted. I think the "rsconnect" subfolder was left intact and may have prevented the app from being published to Beth's shiny account. The "rsconnect" subfolder should have been deleted (because it was specific to Grace), then run and publish the app. To resolve this, we deleted the rsconnect folder from Grace, and we ran the following code in the console (which created a new rsconnect folder):
# deployApp(account = "oas-deer-research", appName = "DeerAgingApp")
## and it was a success...it created a new dcf file in the rsconnect folder that had info specific to the new working directory and shiny accountInfo()
## In the future, if I copy and paste app files like this then delete the rsconnect subfolder before running and publishing...when publishing it will create the rsconnect folder using the image building and files in the working directory that will be associated/published to the shiny account provided 

## here is what was used by Grace and Beth but may not have been needed? as Ryan is able to publish an app to multiple places...
# rsconnect::setAccountInfo(name='mlaging', token='A8A5859852EEA6474DB8C853E22C94B6', secret='4MsMkfI3qx/xp7p2QSLcArtScX+uhgc4Sm0f73rm')
# rsconnect::setAccountInfo(name='oas-deer-research', token='EC8DCD24A6D20DE09A88CD824D9D6EDE', secret='6bKJpdXZYvJB8fSxZwKBpF/Ybhb3HNKI1hqWaBSf') # setting this to Beth's free shiny account

## this was used at some point but may not have been needed?
# library(rsconnect)
#rsconnect::deployApp('Y:/Freeman/RShinyAging')
# rsconnect::deployApp('C:/Users/wojcib/Documents/OAS-deer-research/RShinyAging') # this is publishing the whole package! not just the app name like line 40
###############################################################################


#### deploy code ####
## Ryan publishes an app to diff shiny accounts and doesn't do the token and secret I had done on L32
## instead he uses the following code in the console as an explicit deployment option than line 37
# library(rsconnect)
# rsconnect::deployApp(account = "oas-deer-research", appName = "DeerAgingApp")


###############################################################################
## NOTES ON TROUBLE SHOOTING UPDATE TO CONTACT INFO
## I tried to change my contact phone number and redeploy app but I kept getting a stupid error
## Error in anyUnnamed(list(...)) : could not find function "anyUnnamed"
## issue was the version of shiny bcuz it ran on Ryan's and the runApp was showing the packages loading but then nothing else...and becuz I only changed a tele number...so something outside of R code changed for it to not work
## plus I found one ref saying to comment out library(shiny) for it to run


# https://www.r-bloggers.com/2021/01/installing-older-version-of-a-package/
# remove.packages("shiny")
# library(remotes)
# install_version("shiny", "1.4.0") # I selected not to update dependencies
###############################################################################


###############################################################################
## NOTES ON TEMPDIR ERROR
## This script ran fine on Friday. I believe I had saved and closed the R project? but on Monday when I tried to run the script I immediately got an error:
# Warning in file(con, "w") :
#   cannot open file 'C:\Users\wojcib\AppData\Local\Temp\Rtmp8OKeF8\file414c3cfe38a0': No such file or directory
# Error in file(con, "w") : cannot open the connection
## I highlighted and ran all the code and got this warning:
# Listening on http://127.0.0.1:4564
# Warning in file(open = "w+") :
#   cannot open file 'C:\Users\wojcib\AppData\Local\Temp\Rtmp8OKeF8\Rf414c40cd234f': No such file or directory
# Warning: Error in file: cannot open the connection
# [No stack trace available]
## This reference seems relevant:
## https://github.com/rstudio/shiny/issues/2542
## I used .rs.restartR() in the console to restart R and then hit 'Run App' and it ran as expected. But I am unsure if I needed the temp files that were deleted?
## I also changed my settings so the app temp files are not deleted by Windows. But I am unsure I needed to do that?
###############################################################################


## R tips from Ryan:
## dev ops/data ops...make sure all the version of packages are working together for script
## every time you update R, go thru a process of using R to look at all the folders and the package version and put into a datatable and save as csv then update r and reimport packages from csv....


#### packages ####
# R packages required
library(shiny) # version 1.4.0
library(shinyalert) # version 3.0.0
library(readr) # version 2.1.2
# library(slickR) # photo gallery # version 0.5.0
library(magick) # use to resize images and animate 
library(dplyr) # version 1.0.8
library(stringr) # version 1.4.1
library(tableHTML) # version 2.1.0
library(DT) # version 0.23
# library(tags)
# install.packages("sqldf", dependencies = TRUE)
# library(sqldf) ## csv fix
library(data.table)
# library(readr)
# library(chunked)

## fix for persistent data storage was using google sheet after we couldn't get github docs to work
library(googledrive)
library(googlesheets4)

drive_auth(path = ".secrets/client_secret.json")
gs4_auth(path = ".secrets/client_secret.json")

# options(shiny.error = browser) # this was tried to better pinpoint where code was breaking


#### Pre-processing outside app ####
###############################################################################
## TROUBLE SHOOTING HOW TO SAVE PERSISTENT DATA
# library(RCurl) # using github for master data storage; getURL
# library(rio) # different package for accessing URL
# install_formats("rio")
## RCurl method
# backupfilepath <- getURL("https://raw.githubusercontent.com/OAS-deer-research/RShinyAging/main/MLAgingBackUp2022.csv")
# masterfilepath <- getURL("https://raw.githubusercontent.com/OAS-deer-research/RShinyAging/main/MLAgingMaster2022.csv")
## rio method
# backupfilepath <- "https://raw.githubusercontent.com/OAS-deer-research/RShinyAging/main/MLAgingBackUp2022.csv"
# masterfilepath <- "https://raw.githubusercontent.com/OAS-deer-research/RShinyAging/main/MLAgingMaster2022.csv"
# backupfilepath <- "https://docs.google.com/spreadsheets/d/1gWZRkBXDZpJ3dAgX9W_5X9o1hY8Kd6eW_bWvXGFO45Y/edit#gid=1363872266"
# masterfilepath <- "https://docs.google.com/spreadsheets/d/1NoWtudfDVtnyFZJIAMjinWwS-FSf4OY2I2ObfuEnEHA/edit#gid=580433404"
###############################################################################
backupfilepath <- "https://docs.google.com/spreadsheets/d/1gWZRkBXDZpJ3dAgX9W_5X9o1hY8Kd6eW_bWvXGFO45Y/edit#gid=1363872266"
masterfilepath <- "https://docs.google.com/spreadsheets/d/1NoWtudfDVtnyFZJIAMjinWwS-FSf4OY2I2ObfuEnEHA/edit#gid=580433404"

## there should be 82 DMUs
## these dmus were not the same as the template...this should be updated so that the naming conventions in the template and here are the same as the aging scripts on github.
## Menominee Forest wasn't included but is an option in template
## St Croix was spelled St. Croix but we don't want the . because of shapefile name
## Fond du Lac was spelled Fond Du Lack and our other scripts use du not Du
dmus <- as.list(sort(c("Vernon Farmland", "Crawford Farmland", "Grant Farmland", 
                       "Richland Farmland", "Sauk Farmland", "Columbia Farmland",
                       "Dodge Farmland", "Washington Farmland", "Ozaukee Farmland", 
                       "Iowa Farmland", "Dane Farmland", "Jefferson Farmland", 
                       "Waukesha Farmland", "Milwaukee Farmland", "Lafayette Farmland", 
                       "Green Farmland", "Rock Farmland", 
                       "Walworth Farmland", "Racine Farmland", "Kenosha Farmland",
                       "Adams Farmland", "Barron Farmland", "Brown Farmland", 
                       "Buffalo Farmland", "Chippewa Farmland", 
                       "Calumet Farmland", "Chippewa Forest",
                       "Clark Farmland", "Eau Claire Farmland", "Door Farmland", 
                       "Dunn Farmland", "Fond Du Lac Farmland", "Green Lake Farmland",
                       "Jackson Farmland", "Juneau Farmland", "Kewaunee Farmland", 
                       "La Crosse Farmland", "Manitowoc Farmland", "Marathon Farmland",
                       "Marinette Farmland", "Marquette Farmland", "Monroe Farmland", 
                       "Oconto Farmland", "Outagamie Farmland", "Pepin Farmland", 
                       "Pierce Farmland", "Polk Farmland", "Portage Farmland", 
                       "Shawano Farmland", "Sheboygan Farmland", "St. Croix Farmland",
                       "Trempealeau Farmland", "Waupaca Farmland", "Waushara Farmland",
                       "Winnebago Farmland", "Wood Farmland","Adams Forest", "Clark Forest", 
                       "Eau Claire Forest","Jackson Forest", "Juneau Forest", "Monroe Forest", 
                       "Wood Forest", "Ashland Forest", "Bayfield Forest", "Burnett Forest",
                       "Douglas Forest", "Florence Forest", "Forest Forest", 
                       "Iron Forest", "Langlade Forest", "Lincoln Forest", "Marinette Forest", 
                       "Oconto Forest", "Oneida Forest",
                       "Price Forest", "Rusk Forest", "Sawyer Forest","Taylor Forest", 
                       "Vilas Forest", "Washburn Forest", "Menominee Forest")))

cnames <- c("DeerID", "FirstName", "LastName", "Processor", "County_of_Harvest",
            "Harvest_Season", "Zone", "Sex", "Age", "Antler_Characteristics",
            "Comments")


#### UI - User Interface ####
ui <- fluidPage(
  
  # Application title
  titlePanel(
    #include WDNR logo with title 
    title = shiny::span(img(src = "DNR_logo.jpg", height = 100), 
                        "Deer Processor Aging Data App")),
  # Code below creates the welcome page and text that goes on it
  navbarPage(" ", 
             id = 'tabs', 
             # tabPanel(("Welcome"), ## Welcome Page 
             #          h2(strong("ATTENTION: the app is temporarily down! Check back in a few days to use the app. In the meantime, continue to save your data using the Excel template on your local computer.")),
             #          h2("Welcome to the WDNR app for aging data entry. This process involves 6 steps. Be sure to follow them",strong("exactly"),"!"),
             #          h3("1. Use the Excel template to record aging data at meat processors. Save as .csv on your computer."),
             #          h3("2. Upload your .csv to the app. The app will recode your .csv data and format to a standardized version (ie. adds DMU column, 'doe' or 'Doe' becomes 'Female', etc.) and adds an error column."),
             #          h3("3. Download standardized .csv to your computer and use the error descriptions to make corrections (note: a row may have more than one error or require multiple changes to correct)."),
             #          h3("4. Delete the error column and save this corrected file to your computer. Re-upload the corrected .csv to the app."),
             #          h3("5. Repeat steps 3-4 if not all errrors have been addressed."),
             #          h3("6. When your .csv returns no errors, a save button will appear on the left side of the screen. Click to save your .csv to the database. By the end, you should have a final .csv file on your computer identical to the one you save to the app. Keep this for your records."),
             #          h3("7. Use the 'Data Review' tab to double check the data summary and ensure you have uploaded all of your deer ages at each processor."),
             #          br(),       
             #          # Provide contact information for app questions/issues
             #          h4("Contact Info"),               
             #          h5("Questions About App", strong("Beth Wojcik"), 
             #             "(she/her/hers)", strong("beth.wojcik@wisconsin.gov","(608) 590-8013")),
             #          h5("General Aging Questions", strong("Dan Storm, "), 
             #             strong("danielj.storm@wisconsin.gov","(715) 401-2715"))
             # ), #close tabpanel
             
             #### Upload CSV Data  ####
             tabPanel("Data Upload", #creates the second page to upload data
                      h2("Upload and format aging data from meat processors:", align = "center"),
                      h4("1. Use the Excel template emailed to you to record aging data from meat processors. Populate the DeerID column with your first row of aging data as 01, then enumerate down the DeerID column for each row of data (i.e., 1, 2, 3, 4, etc). The app will change the DeerID to be a combination of First Name, Last Name, and DeerID. Therefore, if you are uploading more than one file (e.g., you have a separate file for each processor), then you should make sure that the numbering continues sequentially for all files (e.g., if your first file ends with DeerID 10, then your second file should start with DeerID 11). Otherwise upload one .csv file of all your aging data. If you add data to it later, it can be re-uploaded without duplicating data as long as the sequential numbering is continued."),
                      h4(img(src = "DeerIDcolumn.jpg", height = 300)),
                      h4("2. Save your data as .csv on your computer. Because we are using a comma separated value file, YOU CANNOT USE A COMMA IN ANY CELL (i.e., don't use a comma when providing a detailed comment in the comments column)."),
                      h4("3. Within this app, below the Contact Info, click “Choose File” to select your aging data file. The app will recode your .csv data and format it to a standardized version (i.e., '5-Apr' becomes 'Age_4-5', 'doe' or 'Doe' becomes 'Female', etc.). It will also add an error column."),
                      h4("4.	If there are errors in the error column, go to step 5. If no errors, then go to step 8."),
                      h4("5.	If there is an error in your data, then click the red 'Download to Make Corrections' button. This will download the standardized .csv to your computer and you will use the error descriptions detailed on this page to make corrections (note: a row may have more than one error or require multiple changes to correct)."),
                      h4("6.	Within excel, delete the error column and save this corrected file to your computer. Re-upload the corrected .csv to the app by using the “Choose File” button."),
                      h4("7.	Repeat steps 5-6 if not all errrors have been addressed."),
                      h4("8.	When your .csv returns no errors (i.e., the Error column shows NA for each row), a green ‘Save to Database’ button will appear on the left side of the screen. Click to save your .csv to the database. By the end, you should have a final .csv file on your computer identical to the one you save to the app. Keep this for your records."),
                      h4("9.	Use the 'Data Review' tab to ensure you have uploaded all of your deer ages at each processor. It is a good idea to see if the summary matches what you intended to submit. You will see a summary of the data you entered by selecting your name or your processor. You can also see a summary of all data submitted for a particular DMU."),
                      br(),   
                      h4("Contact Info"),               
                      h5("Questions About App:", strong("Beth Wojcik, "), strong("beth.wojcik@wisconsin.gov","(608) 590-8013")),
                      h5("General Aging Questions:", strong("Dan Storm, "), 
                         strong("danielj.storm@wisconsin.gov","(715) 401-2715")),
                      br(),   
                      tags$hr(),#puts a blank line in
                      fluidRow(
                        column(width = 8, #sets side panel length
                               sidebarLayout(
                                 sidebarPanel( #side panel
                                   fileInput("MLUpload", "Select the aging data file in .csv format:", #the file they upload is called "MLUpload"
                                             NULL,
                                             multiple = F, accept = c(".CSV",".csv"), #change to T for more than one csv, requires changes below as well 
                                             buttonLabel = "Choose File"), #what is on the button
                                   tableOutput("error_table"), #error table doesn't actually appear - relic of app dev, this needs to be created but doesn't need to print.
                                   uiOutput("download_button"), #creates a download button
                                   uiOutput("save_button"), #when certain criteria are met, the save button appears
                                   h3(strong("Error descriptions:"), align = "left"), #still in the side panel
                                   h4(strong("Invalid DMU:"), "the county or zone is either misspelled or this is a non-existent county/zone combination (ex. Dane Forest or Bayfield Farmland).", align = "left"),
                                   h4(strong("Invalid antler combination:"), "a doe or fawn with antler characteristics. Must either correct age, sex, or antler characteristics (may need to change more than one).", align = "left"),
                                   h4(strong("Headless doe:"), "we cannot age a headless doe because it requires antler characteristics. Either correct sex if it's actually a buck, or remove the doe from your data.", align = "left"),
                                   h4(strong("Enter antler info:"), "an adult buck (non-fawn) should have antler characteristics. If these are unknown, use 'unknown' not 'NA'.", align = "left"),
                                   h4(strong("Headless missing antlers:"), "because we assign ages to headless samples based on antler characteristics, this individual cannot be used in the analysis and should be removed from your data.", align = "left"),
                                   h4(strong("Incomplete data:"), "missing DMU, age, sex, etc. Missing field (i.e., invalid) must be corrected or data point removed.", align = "left")
                                 ), #cloes sidebarPanel for MLUpload
                                 # Display the formatted data table
                                 mainPanel( #prints the main panel with the csv and error column
                                   tableHTML_output("Table")
                                 ) #close main panel
                               ) #close sidebarLayout
                        ) #close column with width = 6
                      ) #close fluidRow
             ), #close tabpanel for CSV upload
             
             tabPanel("Data Review", #creates the third panel for data review
                      h2("Review data you've entered:", align = "center"),
                      h4("Select the variable by which you would like to sort (your name, processor name, or DMU). Be patient as it may take awhile to react and populate the variable if there is a lot of data.", align = "left"),
                      h4("Review summary tables to ensure numbers match your records. Note that all three tables are showing the same individual deer (same total number) but sliced in different ways. These are indended to be interpreted independent of one another.", align = "left"),
                      h4("If the numbers do not look correct, reach out to Beth Wojcik (beth.wojcik@wisconsin.gov) for help troubleshooting.", align = "left"),
                      textOutput("text"),
                      tags$hr(), #blank row
                      fluidRow(
                        column(width = 8,
                               sidebarLayout(
                                 sidebarPanel(
                                   radioButtons("Search_By", "Search_By", #radio button for search choice
                                                choices = c("Name", "Processor", "DMU")), #options for radio buttons
                                   uiOutput("ReviewChoice")), #will display the choice selected in the radio button
                                 mainPanel( #puts three tables in the main panel with the following horizontal breakdown
                                   fluidRow(splitLayout(cellWidths = c("30%", "30%", "40%"),
                                                        tableOutput("ReviewTableSex"),
                                                        tableOutput("ReviewTableAge"),
                                                        tableOutput("ReviewTableSexAge")))
                                 ) #close mainpanel
                               ) #close sidebar layout
                        ) #close column
                      ) #close fluidrow
             )#close tabpanel
  ),#close navbar
)#close UI


###### Define server logic to read selected file ----######
server <- function(input, output, session) {
  
#### Save button ####
  output$save_button <- renderUI({ #save button 
    req(input$MLUpload) #don't run below unless there's a csv uploaded
    if(error_table_count()==0){ #save button only appears if there are 0 errors
      actionButton("MLSave", "Save to Database", style="color: #fff; background-color: #FF0000; 
                border-color: #FF000", 
                   icon("download"))
    } # close if statement
  }) # close renderUI
  
  observe({print(input$tabs)})

#### Make dataframe ####  
  
  ###############################################################################
  ## TROUBLE SHOOTING EXCEL TEMPLATE ISSUE
  ## the excel template caused formatting issues and created a large csv file that could have many rows of NA which caused the app to crash. We used the following references to create code that would read in a file line by line and stop when it got to a line of all NAs:
  ## https://stackoverflow.com/questions/23197243/how-to-read-only-lines-that-fulfil-a-condition-from-a-csv-into-r
  ## https://stackoverflow.com/questions/41872288/reading-a-messy-csv-using-readlines-until-a-certain-row-cell-value
  ###############################################################################
  
  df <- reactive({ 
    # cleans the csv that gets uploaded, most of this code came from the Part 1 aging script
    # Much of this cleaning may not be necessary if the Excel template works and restricts as intended.
    # It's not bad to have it anyway as it can catch anything Excel misses. 
    
## initial test attempt from Lydia
    # line <- 0L
    # input <- "start" ## R didn't like this was called input...confusing b/c of the shiny input
    # while(input != ",,,,,,,,,," ) {
    #   line <- line + 1L
    #   input <- read_lines( "testing.csv", skip = line - 1L, n_max = 1L )
    # }
    # x <- read_lines( "testing.csv", n_max = line - 1L)
    # 
    # data <- data.frame(matrix(ncol = 11, nrow = 0))
    # colnames(data) <- gsub('"', '', strsplit(x[1], ',')[[1]], fixed = TRUE)
    # 
    # df1 <- strsplit(x[-1], ",")
    # df1 <- do.call(rbind, df1)
    # df1 <- df1
    # df1 <- as.data.frame(df1)
    # colnames(df1) <- gsub('"', '', strsplit(dat[1], ',')[[1]], fixed = TRUE)[1:ncol(df1)]
    ## merge data and df1
    
## old attempt at addressing files that have rows and rows of blanks (from stupid excel template)
    # entry <- read_with_condition( input$MLUpload$datapath, lines.guess = 100L )
    
    # entry <- readr::read_lines(input$MLUpload$datapath, skip_empty_rows = TRUE, n_max = 1000)
    # entry <- entry[seq(1, grep("Data", lines)[1] - 1)]
    
    # line <- 0L
    # input <- "start" 
    # while(input != ",,,,,,,,,," ) {
    #   line <- line + 1L
    #   input <- read_lines( input$MLUpload$datapath, skip = line - 1L, n_max = 1L )
    # }
    # entry <- as.data.frame(read_lines( input$MLUpload$datapath, n_max = line - 1L))
    
    # f <- function(x, pos) subset(x, nrow = 1000)
    # entry <- read_delim_chunked(input$MLUpload$datapath, 
    #                             callback = f, chunk_size = 1000, 
    #                             skip_empty_rows = TRUE)
    
    # entry <- read.csv(input$MLUpload$datapath, nrows = 1000)
    # entry <- entry %>% filter_all(any_vars(!is.na(.)))
    
    # x <- as.data.frame(input$MLUpload$datapath)
    # entry <- readLines(input$MLUpload$datapath, n = 1000)
    # entry <- as.data.frame(entry)
    
    ###############################################################################
    ## Lydia's code worked and then for some strange reason it did not
    ## Ryan helped trouble shoot and change this chunk of code
    ## trying to get the last non-empty line of input file
    ## & means 'and'
    ## && means an early exit...checks the first thing if remaining could still resolve as true then continues on
    ## reason is_empty is placed first...the order matters
    
    ## start at line 0
    line <- 0L
    ## start with the upload file
    datainput = input
    ## when uploading the file, read each line as long as the line is not empty
    while(!rlang::is_empty(datainput) && datainput != ",,,,,,,,,,") {
      ## the file has this many lines to it
      line <- line + 1L
      ## read in only valid lines from the upload file
      datainput <- read_lines(input$MLUpload$datapath, skip = line, n_max = 1L)
      # print(datainput) # use this as a trouble shooting tool 
    }
    
    ## raw data with header and no extra blank rows
    x <- read_lines(input$MLUpload$datapath, n_max = line)
    ## adding na argument because now the upload is showing "Na" and not creating errors correctly
    # x <- read_lines(input$MLUpload$datapath, n_max = line, na = c("", "NA", "Na"))
    ## look at what it produced from upload
    # print(x)
    
    ## tyring to troubleshoot re-upload with extra columns
    # if(colnames(x)[1]=="X" | colnames(x)[1]==""){ #If they're re-uploading, there will be a column called "X" that just numbers rows 1 - n. This line removes that.
    #   # entry <- entry %>%
    #   #   dplyr::select(-X)
    #   x <- x %>%
    #     rename(Remove = X,
    #            Remove = ",") %>% 
    #     dplyr::select(-Remove)
    #   ## tyring to fix recode creating Na
    #   # mutate(Antler_Characteristics = na_if(Antler_Characteristics, "Na"))
    #   print(x)
    # }
    # print(x)
    
    ## data = blank dataframe
    data <- data.frame(matrix(ncol = 11, nrow = 0))
    ## give the blank df the same header as our upload file
    colnames(data) <- gsub('"', '', strsplit(x[1], ',')[[1]], fixed = TRUE)
    
    ## df1 = rows of upload data
    ## creates a list comprised of each row of upload file except the header row
    df1 <- strsplit(x[-1], ",")
    print(df1)
    ## binds the strsplit together into a matrix
    df1 <- do.call(rbind, df1)
    ## turns matrix into a dataframe with X1-X11 column headings
    df1 <- data.frame(df1)
    ## gives df1 the same headings as from the uploaded data file
    colnames(df1) <- gsub('"', '', strsplit(x[1], ',')[[1]], fixed = TRUE)[1:ncol(df1)]
    # colnames(df1) <- data[1:ncol(df1)]
    print(df1)
    
    ## merge data and df1
    ## data is just the header and df1 is the header with data
    entry <- merge(data, df1, 
                   by = gsub('"', '', strsplit(x[1], ',')[[1]], fixed = TRUE)[1:ncol(df1)], 
                   all = TRUE, 
                   no.dups = TRUE)
    colnames(entry) = cnames
    entry <- as.data.frame(entry)
    # entry <- entry %>%
    #   mutate_all(na_if,"") %>%
    #   mutate(Comments = as.character(Comments))
    
## old attempt using fread
    # entry <- fread(entry,
    #                col.names = cnames,
    #                na.strings=c("", "NA"),
    #                header = TRUE,
    #                   colClasses=c("DeerID"="character",
    #                                "FirstName"="character",
    #                                "LastName"="character",
    #                                "Processor"="character",
    #                                "County_of_Harvest"="character",
    #                                "Harvest_Season"="character",
    #                                "Zone"="character",
    #                                "Sex"="character",
    #                                "Age"="character",
    #                                "Antler_Characteristics"="character",
    #                                "Comments"="character"),
    #                   blank.lines.skip=TRUE,
    #                data.table = FALSE,
    #                showProgress = TRUE
    #                ) #only setup to allow one csv
    
## trying this before recode
    # entry <- replace(entry, entry == "Na", NA)
    # entry <- replace(entry, is.na(entry), NA)
    # entry <- replace(entry, is.null(entry), NA)
    
    entry$Antler_Characteristics = str_to_title(tolower(entry$Antler_Characteristics))
    entry$Antler_Characteristics = recode(entry$Antler_Characteristics,
                                          "Legal Spikes"="LegalSpikes",
                                          "Uk"="Unknown",
                                          "Branched" = "Forked",
                                          "Fork" = "Forked",
                                          .missing = "NA")
    # entry$Antler_Characteristics = recode(entry$Antler_Characteristics,
    #                                       "Legal Spikes"="LegalSpikes",
    #                                       "Uk"="Unknown",
    #                                       "Branched" = "Forked",
    #                                       "Fork" = "Forked")
    entry$Harvest_Season = str_to_title(tolower(entry$Harvest_Season))
    entry$Harvest_Season = recode(entry$Harvest_Season,
                                  "Bow"="Archery", "Gun" = "Firearm")
    entry$Age = str_to_title(tolower(entry$Age))
    entry$Age = recode(entry$Age,
                       "1"="Yearling",
                       "1 (Yearling)"="Yearling",
                       "2"="Age_2.5",
                       "3"="Age_3.5",
                       "4-5"="Age_4-5",
                       "5-Apr"="Age_4-5",
                       "5"="Age_4-5",
                       "4"="Age_4-5",
                       "6-8"="Age_6-8",
                       "6"="Age_6-8",
                       "7"="Age_6-8",
                       "8"="Age_6-8",
                       "8-Jun"="Age_6-8",
                       "9-11"="Age_9-11",
                       "9"="Age_9-11",
                       "10"="Age_9-11",
                       "11"="Age_9-11",
                       "11-Sep"="Age_9-11",
                       "12-Sep"="Age_9-11",
                       "9-12"="Age_9-11",
                       "F"="Fawn",
                       "12+"="Age_12+",
                       "12"="Age_12+",
                       "Uk-Headless Deer"="Headless",
                       "Uk-Headless"="Headless",
                       "Uk - Headless Deer"="Headless",
                       .missing = "NA")
    entry$Sex = str_to_title(tolower(entry$Sex))
    ## recode changes NA to Null...this caused problems! If statements in error table were trying to read a null
    entry$Sex = recode(entry$Sex,
                       "F"="Female","M"="Male","Doe"="Female","Buck" = "Male",
                       .missing = "NA")
    entry$DMU <- paste(entry$County_of_Harvest, entry$Zone, sep = " ")
    entry %>% relocate(DMU, .after = DeerID)
    entry$Processor <- str_to_title(tolower(entry$Processor))
    
    entry$DeerID <- paste0(entry$LastName, entry$FirstName, entry$DeerID)
    ## can we alter this so it is only created if it is not a re-upload??????????
    
    
    ## trying this placed after recode
    # entry <- replace(entry, entry == "", NA)
    entry <- replace(entry, entry == "Na", NA)
    entry <- replace(entry, is.na(entry), NA)
    # entry <- replace(entry, is.null(entry), NA)
    # entry <- replace(entry, entry == "", "NA")
    # entry <- replace(entry, entry == "Na", "NA")
    # entry <- replace(entry, is.na(entry), "NA")
    
    # print(entry)
    
    if(colnames(entry)[1]=="X"){ #If they're re-uploading, there will be a column called "X" that just numbers rows 1 - n. This line removes that.
    # if(colnames(entry)[1]=="X" | colnames(entry)[1]==""){ #If they're re-uploading, there will be a column called "X" that just numbers rows 1 - n. This line removes that.
      entry <- entry %>%
        dplyr::select(-X)
      # entry <- entry %>%
      #   rename(Remove = X,
      #          Remove = "") %>% 
      #   dplyr::select(-Remove) %>% 
      #   dplyr::select(-Remove)
        ## tyring to fix recode creating Na
        # mutate(Antler_Characteristics = na_if(Antler_Characteristics, "Na"))
      }
    ## this may fix the issue of null and is.na in error flag table
    # entry <- replace(entry, is.null(entry), NA)
    entry
  } #close reactive
  ) #close reactive
    
## OG way to create unique DeerID
  #   entry %>% relocate(DMU, .after = DeerID)
  #   entry$Processor <- str_to_title(tolower(entry$Processor))
  #   # Create a unique DeerID for each row in the csv
  #   # create_unique_ids <- function(n, seed_no = 1, char_len = 5){
  #   #   set.seed(seed_no)
  #   #   pool <- c(letters, LETTERS, 0:9)
  #   #   res <- character(n) # pre-allocating vector is much faster than growing it
  #   #   for(i in seq(n)){
  #   #     this_res <- paste0(sample(pool, char_len, replace = TRUE), collapse = "")
  #   #     while((this_res %in% res)|(this_res %in% master()$DeerID)){ # if there was a duplicate, redo
  #   #       this_res <- paste0(sample(pool, char_len, replace = TRUE), collapse = "")
  #   #     } #close wihle
  #   #     res[i] <- this_res
  #   #   } #close for
  #   #   res
  #   # } #close function
  #   # entry$DeerID <- create_unique_ids(nrow(entry), seed_no = 23)
  #   entry$DeerID <- paste0(entry$LastName, entry$FirstName, entry$DeerID)
  #   if(colnames(entry)[1]=="X"){ #If they're reuploading, there will be a columnm called "X" that just numbers rows 1 - n. This line removes that.
  #     entry <- entry %>%
  #       dplyr::select(-X)}
  # ## this may fix the issue of null and is.na in error flag table
  #   # entry <- replace(entry, is.null(entry), NA)
  #   entry
  # } #close reactive
  # ) #close reactive
  
  #### download button ####
  output$download_button <- renderUI({
    req(input$MLUpload) #require a csv upload
    if(error_table_count()>0){ #If there are errors, show the download button (not save)
      downloadButton("downloadData", "Download to Make Corrections",
      style="color: #fff; background-color: #FF0000; border-color: #FF0000")}
  } #close renderUI
  ) #close renderUI
  
  # Downloadable csv of selected dataset ----
  output$downloadData <- downloadHandler(
    ## here remove DMU column and suppress row names when creating file
    
    # when writing csv file , when specifying data
    # dat()[,-10]
    ## grep out file name not complete datapath
    filename = paste0(sub(".csv$", "", basename(input$MLUpload$name)), "_errors.csv"),
                     # "MyAgingData2022.csv", #name for the file downloaded via the app (they should change it to something that makes more sense for their computer)
    content = function(MLUpload) {
      write.csv(color(), MLUpload, row.names = F) #dataframe is called color() because I originally intended to color the rows that had errors, then realized that wouldn't work in csv formatting.
    } #close content = 
  ) #close downloadHandler
  
  # Download as xyz title, I recommend you change that to something to keep ion your records and that will be useful to you!! 
  # Mention that if you repeat the process, it will name it xyz_2.
  
  #### save button ####
  output$save_button <- renderUI({
    req(input$MLUpload)
    if(error_table_count()==0){ #If there are no errors, show the save button, not the download one
      actionButton("MLSave", "Save to Database", 
      # style="color: #fff; background-color: #337ab7; border-color: #2e6da4",
      style="color: #fff; background-color: #32CD32; border-color: #32CD32",
                   icon("download"))
    } # close if statement
  }# close renderUI
  ) # close renderUI
  
  #### error flags table ####
  #Apply rules for error flags
  error_table <- reactive({
    errors <- data.frame(matrix(ncol = 2, nrow = 0))
    colnames(errors) <- c('DeerID', 'Error')
    errors$DeerID <- as.character(errors$DeerID)
    errors$Error <- as.character(errors$Error)
    for (i in 1:nrow(df())){
      errors_st <-  "" #make errors an empty string
      # invalid_antler_combination
      if (((df()$Sex[i] == "Female")) & (df()$Age[i] != "Fawn") & (!is.na(df()$Antler_Characteristics[i]))){
        new_error <- "invalid_antler_combination"
        errors_st <- paste(errors_st, new_error, sep = " ")
      } #close if statement
      # invalid_antler_combination
      if ((df()$Age[i] == "Fawn") & (!is.na(df()$Antler_Characteristics[i]))){
        new_error <- "invalid_antler_combination"
        errors_st <- paste(errors_st, new_error, sep = " ")
      }#close if statement
      # Male w NA antlers
      if ((df()$Sex[i] == "Male") & (df()$Age[i] != "Fawn") & (is.na(df()$Antler_Characteristics[i]))){
        new_error <- "enter_antler_info"
        errors_st <- paste(errors_st, new_error, sep = " ")
      }#close if statement
      # Headless male wo antlers
      # if ((df()$Age[i] == "Headless") & (df()$Sex[i] == "Male") & (is.na(df()$Antler_Characteristics[i]))){
      #   new_error <- "headless_missing_antlers"
      #   errors_st <- paste(errors_st, new_error, sep = " ")
      # }#close if statement
      # Headless male wo antlers
      if ((df()$Age[i] == "Headless") & (df()$Sex[i] == "Male") & (is.na(df()$Antler_Characteristics[i])) | (df()$Age[i] == "Headless") & (df()$Sex[i] == "Male") & (df()$Antler_Characteristics[i] == "")){
        new_error <- "headless_missing_antlers"
        errors_st <- paste(errors_st, new_error, sep = " ")
      }#close if statement
      
      # Headless females
      if ((df()$Age[i] == "Headless") & (df()$DMU[i] %in% dmus) & (df()$Sex[i] == "Female")){
        new_error <- "headless_doe"
        errors_st <- paste(errors_st, new_error, sep = " ")
      }#close if statement
      #  Invalid DMU
      if (!(df()$DMU[i] %in% dmus)){
        new_error <- "invalid_DMU"
        errors_st <- paste(errors_st, new_error, sep = " ")
      } #close if statement
      # if ((is.na(df()$Sex[i]))) {
      #   new_error <- "incomplete_data"
      #   errors_st <- paste(errors_st, new_error, sep = " ")
      # }#close if statement
      # if ((is.na(df()$Age[i]))) {
      #   new_error <- "incomplete_data"
      #   errors_st <- paste(errors_st, new_error, sep = " ")
      # }#close if statement
      # if ((df()$Sex[i] == "NA")) {
      #   new_error <- "incomplete_data"
      #   errors_st <- paste(errors_st, new_error, sep = " ")
      # }#close if statement
      if ((is.na(df()$Sex[i])) | (df()$Sex[i] == "")) {
        new_error <- "incomplete_data"
        errors_st <- paste(errors_st, new_error, sep = " ")
      }#close if statement
      # if ((df()$Sex[i] == "NA")) {
      #   new_error <- "incomplete_data"
      #   errors_st <- paste(errors_st, new_error, sep = " ")
      # }#close if statement
      if ((df()$Age[i] == "NA") | (df()$Age[i] == "")) {
        new_error <- "incomplete_data"
        errors_st <- paste(errors_st, new_error, sep = " ")
      }#close if statement
      if ((is.na(df()$DMU[i]))) {
        new_error <- "incomplete_data"
        errors_st <- paste(errors_st, new_error, sep = " ")
      }
      
      ## adding error for blank in any cell (except Comments)
      if ((df()$DeerID[i] == "")) {
        new_error <- "incomplete_data"
        errors_st <- paste(errors_st, new_error, sep = " ")
      }#close if statement
      if ((df()$FirstName[i] == "")) {
        new_error <- "incomplete_data"
        errors_st <- paste(errors_st, new_error, sep = " ")
      }#close if statement
      if ((df()$LastName[i] == "")) {
        new_error <- "incomplete_data"
        errors_st <- paste(errors_st, new_error, sep = " ")
      }#close if statement
      ## Erin Grossman recorded Processor == NA for samples from DMAP cooperator
      # if ((df()$Processor[i] == "") | (is.na(df()$Processor))) {
      #   new_error <- "incomplete_data"
      #   errors_st <- paste(errors_st, new_error, sep = " ")
      # }#close if statement
      if ((df()$County_of_Harvest[i] == "")) {
        new_error <- "incomplete_data"
        errors_st <- paste(errors_st, new_error, sep = " ")
      }#close if statement
      if ((df()$Harvest_Season[i] == "")) {
        new_error <- "incomplete_data"
        errors_st <- paste(errors_st, new_error, sep = " ")
      }#close if statement
      if ((df()$Age[i] == "")) {
        new_error <- "incomplete_data"
        errors_st <- paste(errors_st, new_error, sep = " ")
      }#close if statement
      ## this doesn't work for some reason 
      # if ((df()$Antler_Characteristics[i] == "")) {
      #   new_error <- "incomplete_data"
      #   errors_st <- paste(errors_st, new_error, sep = " ")
      # }#close if statement
      
      if(errors_st != ""){
        errors_working <- data.frame(matrix(data = c(df()$DeerID[i], errors_st), ncol = 2, nrow = 1))
        colnames(errors_working) <- c('DeerID', 'Error')
        errors <- bind_rows(errors, errors_working)}
      # print(errors)
      #only line in if statement should be errors <- errors + new_error (lookup the string)
      #close if statement
    } #close for loop
    errors
  } # close reactive
  ) # close error table reactive

  color <- reactive({
    # take DMU column out of df above
    # sandbox <- df()
    # sandbox <- df()[-11]
    ## removes DMU column if there is a download so the instructions can stay the same (delete error column)
    sandbox <- df()[-12] 
    sandbox <- left_join(sandbox, error_table()) 
    sandbox
    # print(sandbox)
  } #close reactive
  ) #close reactive
  
  
  output$Table <- renderTable({
    req(input$MLUpload)
    color() #main panel table - csv with standardization and cleaning rules
  }, #close render table
  striped = T, bordered = T) #close renderTable
  
  error_table_count <- reactive(
    {nrow(error_table())} #calculates the number of non-NA errors, this number determines whether we see the download or save button.
  )#close reactive
  
  
  #### updating master and back up files ####
  observeEvent(input$MLSave, {
    # 1. read in the master file
    # backup <- read.csv(text = masterfilepath)
    ## read in the file RCurl method
    # backup <- read.csv(file = textConnection(masterfilepath))
    ## read in the file rio method
    # backup <- rio::import("https://raw.githubusercontent.com/OAS-deer-research/RShinyAging/main/MLAgingMaster2022.csv")
    ## read in file using googlesheets
    ## read in master google sheet
    # ssid <- as_sheets_id(backupfilepath)
    # class(ssid)
    # unclass(ssid)
    # ssid
    # read_sheet(ssid)
    read_sheet(backupfilepath) # original back up is empty
    read_sheet(masterfilepath) # original master has data
    
    dat <- read_sheet(masterfilepath) ## save the master as a dataframe to resave

    # 2. save the file data to a backup file
    # write.csv(backup, file = backupfilepath, 
    #           row.names = FALSE)
    # export(backup, file = backupfilepath, 
    #            row.names = FALSE)
    # rio::export(backup, "https://raw.githubusercontent.com/OAS-deer-research/RShinyAging/main/MLAgingBackUp2022.csv")
    # rio::export(backup, backupfilepath)
    ## write master to backup before appending new data to master
    newbackup <- sheet_write(dat, ss = backupfilepath, sheet = "MLAgingBackUp2022") ## replace empty back up with master df which has data..but this created a new sheet
    # sheet_write(dat, ss = backupfilepath, sheet = "MLAgingBackUp2022")
    # backup <- sheet_write(master)
    # sheet_append(backup, master)
    
    # 3. Add the new data to the old data
    # x <- rbind(backup, df())
    # Arrange by DeerID
    # x <- dplyr::arrange(x, as.numeric(DeerID))
    # update the master data file
    # write.csv(x, file = masterfilepath, 
    #           row.names = FALSE)
    # export(x, file = masterfilepath, 
    #            row.names = FALSE)
    # rio::export(x, "https://raw.githubusercontent.com/OAS-deer-research/RShinyAging/main/MLAgingMaster2022.csv")
    
    # check for duplicates
    nodupes <- df() %>% filter(!(DeerID %in% dat$DeerID))
    # df() <- !duplicated(dat, df())
      
    # sheet_append(masterfilepath, df())
    sheet_append(masterfilepath, nodupes)
    
    #close the else statement
    shinyalert(" ", 
               "ML Aging Master File Updated", "success" )
  } #close observe event statement bracket
  ) #close observe event statement

  
  
  #### FOR REVIEW ####
  output$ReviewChoice  <- renderUI({
   #  review.raw <-read.csv(text = masterfilepath) #read in the entire database
    review.raw <- read_sheet(masterfilepath)
    # review.raw <- rio::import("https://raw.githubusercontent.com/OAS-deer-research/RShinyAging/main/MLAgingMaster2022.csv")
    review.raw$FullName <- paste(review.raw$LastName, review.raw$FirstName, sep = ", ")
    if(input$Search_By == "Name"){ #if the radio button selected is name, filter by name
      selectInput("NameInput", "Enter Your Name:",
                  choices = sort(review.raw$FullName))
    }else if(input$Search_By == "Processor"){ #if the radio button selected is processor, filter by processor
      selectInput("ProcessorInput", "Enter Processor Name:",
                  choices =sort(review.raw$Processor))
    }else if(input$Search_By == "DMU"){ #if the radio button selected is DMU, filter by DMU
      selectInput("DMUInput", "Enter DMU:",
                  choices = sort(review.raw$DMU))
    } #close else if
  } #close renderUI
  ) #close renderUI
  
  output_for_agg  <- reactive({
    review.raw <- read_sheet(masterfilepath)
    # review.raw <- rio::import("https://raw.githubusercontent.com/OAS-deer-research/RShinyAging/main/MLAgingMaster2022.csv")
    review.raw$FullName <- paste(review.raw$LastName, review.raw$FirstName, sep = ", ")
    if(input$Search_By == "Processor"){
      req(input$ProcessorInput)
      ProcessorInput <- input$ProcessorInput
      if (!(ProcessorInput=="")){
        review.raw = review.raw %>% 
          dplyr::filter(Processor == ProcessorInput)
      } #close if 
    } #close larger if
    if(input$Search_By == "Name"){
      req(input$NameInput)
      NameInput <- input$NameInput
      if (!(NameInput=="")){
        review.raw = review.raw %>%  # n # is this a typo
          dplyr::filter(FullName == NameInput)
      } #close if
    } #close larger if
    if(input$Search_By == "DMU"){
      req(input$DMUInput)
      DMUInput <- input$DMUInput
      if (!(DMUInput=="")){
        review.raw = review.raw %>% 
          dplyr::filter(DMU == DMUInput)
      } #close if
    }#close larger if
    review.raw
  }#close reactive
  )#close reactive
  
  
  review.output.sex <- reactive({
    review.raw <- output_for_agg() #aggregate into groups based on sex
    agg.output <- aggregate(review.raw$Age,by=list(review.raw$Sex),FUN=length)
    colnames(agg.output)[1]="Sex"
    colnames(agg.output)[2]="Count"
    agg.output <- agg.output %>% 
      bind_rows(summarise(., #print a summary table based on aggregation
                          across(where(is.numeric), sum),
                          across(where(is.character), ~"Total"))) #close bind_rows
    agg.output
  } #close reactive
  ) #close reactive 
  
  output$ReviewTableSex <- renderTable({
    as.data.frame(review.output.sex())
  }, #close render table
  striped=T,bordered =T
  ) #close renderTable
  
  
  
  review.output.sexage <- reactive({
    review.raw <- output_for_agg() #aggregate into groups based on sexage
    review.raw$sexage <- paste(review.raw$Sex, review.raw$Age, sep = "_")
    agg.output <- aggregate(review.raw$Sex, by=list(review.raw$sexage),FUN=length)
    colnames(agg.output)[1]="SexAge"
    colnames(agg.output)[2]="Count"
    agg.output <- agg.output %>% 
      bind_rows(summarise(.,#print a summary table based on aggregation
                          across(where(is.numeric), sum),
                          across(where(is.character), ~"Total"))) #close bind_rows
    agg.output
  } #close reactive
  ) #close reactive 
  
  output$ReviewTableSexAge <- renderTable({
    as.data.frame(review.output.sexage())
  }, #close render table
  striped=T,bordered =T
  ) #close renderTable
  
  
  review.output.age <- reactive({
    review.raw <- output_for_agg() #aggregate into groups based on age
    agg.output.age <- aggregate(review.raw$Sex,by=list(review.raw$Age),FUN=length)
    colnames(agg.output.age)[1]="Age"
    colnames(agg.output.age)[2]="Count"
    agg.output.age <- agg.output.age %>% 
      bind_rows(summarise(., #print summary table based on aggregation
                          across(where(is.numeric), sum),
                          across(where(is.character), ~"Total")))
    agg.output.age
  } #close reactive
  ) #close reactive 
  
  output$ReviewTableAge <- renderTable({
    as.data.frame(review.output.age())
  }, #close render table
  striped=T,bordered =T
  ) #close renderTable
  
  
  master <- reactive({df <- read_sheet(masterfilepath)
  df$FullName <-  paste(df$LastName, df$FirstName, sep = ", ")
  df
  } #close reactive
  ) #close reactive
} #close server

# Create Shiny app ----
shinyApp(ui=ui, server=server)


