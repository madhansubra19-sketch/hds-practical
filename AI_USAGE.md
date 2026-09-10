# AI usage
Model used: CLAUDE (anthropic) 
General Use: Asked for explanations/fixes when I got error messages
# Questions/Prompts  I asked

##  1. conda couldn't find the enviornment mamba created
My prompt: I pasted my full terminal session from (mamba create, conda activate, python scripts/analyze.py and conda env export commands with their outputs and asked for an explanation of what went wrong):
Error Messages that were pasted with my prompt: "Transaction finished Environment 
removed at prefix: /Users/madhansubramanian/.local/share/mamba/envs/hds-practicalerror    
libmamba Overwriting root prefix is not permitted - aborting.critical libmamba 
Overwriting root prefix is not permitted - aborting. EnvironmentName NotFound: Could not find conda environment: 
hds-practical You can list all discoverable environments with conda info --envs."

Explanation from claude: Since mamba and conda on my machine used difference environment directories, conda activate couldn't see
the env mamba made, which mean the script ran in "base" (no pandas), and conda env export exported base instead of my environment, which is why mamba env create then refused to overwrite the root prefix

Claude's recommendation: Use either mamba or conda don't use both, delete the old environment.yml and redo the process. 
What I did: I used conda and remade a new environment.yml after deleting the old one. 
I chose conda since it is better with environment isolation. 


## 2. renv project hasn't been activated menu kept appearing
Prompt: I pasted what I saw in my r console: "> setwd("~/Desktop/hds-practical")
> renv::init()
- Linking packages into the project library ... Done!
The following package(s) will be updated in the lockfile:

# CRAN -----------------------------------------------------------------------
- cli          [* -> 3.6.5]
- dplyr        [* -> 1.2.0]
- generics     [* -> 0.1.4]
- glue         [* -> 1.8.0]
- lifecycle    [* -> 1.0.5]
- magrittr     [* -> 2.0.4]
- pillar       [* -> 1.11.1]
- pkgconfig    [* -> 2.0.3]
- R6           [* -> 2.6.1]
- renv         [* -> 1.1.8]
- rlang        [* -> 1.1.7]
- tibble       [* -> 3.3.0]
- tidyselect   [* -> 1.2.1]
- utf8         [* -> 1.2.6]
- vctrs        [* -> 0.7.2]
- withr        [* -> 3.0.2]

The version of R recorded in the lockfile will be updated:
- R            [* -> 4.4.2]

- Lockfile written to "~/Desktop/hds-practical/renv.lock".
> install.packages("dplyr")
Restarting R session...
> 
> setwd("~/Desktop/hds-practical")
> renv::init()
This project already has a lockfile. What would you like to do? 

1: Restore the project from the lockfile.
2: Discard the lockfile and re-initialize the project.
3: Activate the project without snapshotting or installing any packages.
4: Abort project initialization.

Selection: install.packages("dplyr")
Enter an item from the menu, or 0 to exit
Selection: source("scripts/analyze.R")
Enter an item from the menu, or 0 to exit
Selection: renv::snapshot()
Enter an item from the menu, or 0 to exit
Selection: y
Enter an item from the menu, or 0 to exit
Selection: 1
- The library is already synchronized with the lockfile.
Restarting R session...
I asked claude why R kept restarting and if i was doing this correctly."

Claude's explanation: Check the Work directory by using getwd(), and if the correct folder was shown
rerun the code. Then run this: source("scripts/analyze.R")

I decided claudes response for checking the work directory was satisfactory since it was asking me to check the wd to begin with. 
I checked the wd using getwd(), noticed it was the right wd and ran: source("scripts/analyze.R") to get the right output from analysis.R


