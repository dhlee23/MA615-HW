## Dae Hyun Lee
## MA615
## Peergrade Assignment


library(tidyverse)
library(magrittr)
library(readxl)
library(RSQLite)
library(DBI)

## Read Data
contrib_all <- read_xlsx("Top MA Donors 2016-2020.xlsx", 
                         sheet = "Direct Contributions & JFC Dist")

JFC <- read_xlsx("Top MA Donors 2016-2020.xlsx", 
                 sheet = "JFC Contributions")
## Build Table
contributors <- select(contrib_all, 
                       contribid, fam, date, contrib, City, State, Zip, Fecoccemp, orgname)
contributors %<>% distinct()

organizations <- select(contrib_all, 
               recipient, party, recipcode, cmteid)
organizations %<>% distinct()
organizations %<>% na.omit()

contribution <- select(contrib_all,
                       contribid, date, amount, recipient, cycle)
contribution %<>% distinct()

recipients <- select(contrib_all, 
                     recipient, party, recipcode, cmteid)
recipients %<>% distinct()

## Database
database <- dbConnect(SQLite(), "daehyun_db.sqlite")
dbWriteTable(database, "contributors", contributors)
dbWriteTable(database, "organization", organizations)
dbWriteTable(database, "contribution", contribution)
dbWriteTable(database, "recipients", recipients)
dbDisconnect(database)
