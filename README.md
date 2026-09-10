# hds-practical LAB 1
Creating a Reporducible Computing Setup!
This lab puts the last two weeks together. Reproducibility starts before you write any analysis code: 
it starts with being able to say exactly what software, versions, and dependencies your work requires,
so someone else (including future-you) can recreate your environment. 
Week 1 got you a real Git/GitHub repo; 
Week 2 got you a working virtual environment, a container, and a habit of verifying AI-suggested fixes instead of trusting them blind.
Lab 1 is those three things, done for real, on your own project structure instead of a toy one.

Directions for the Lab can be found here: https://github.com/gwcbi/applied-computing-HDS/blob/main/labs/lab1-reproducible-setup/README.md

## Prerequisites
In order to complete this lab, there are certain software/packages that must be installed prior to starting 
This includes:
1. Git https://github.com/gwcbi/applied-computing-HDS/blob/main/lectures/week01-computing-environments/README.md
2. Conda (Miniforge) https://github.com/gwcbi/applied-computing-HDS/blob/main/lectures/week02-reproducible-research-fundamentals/README.md
3. R/Rstudio https://github.com/gwcbi/applied-computing-HDS/blob/main/lectures/week01-computing-environments/README.md
4. IDE for python https://github.com/gwcbi/applied-computing-HDS/blob/main/lectures/week01-computing-environments/README.md
5. Docker Desktop https://github.com/gwcbi/applied-computing-HDS/blob/main/lectures/week02-reproducible-research-fundamentals/README.md


## How to clone this Repo
Run this in terminal: 
```bash
   git clone https://github.com/madhansubra19-sketch/hds-practical.git
   cd hds-practical
   conda env create -f environment.yml
   conda activate hds-practical
   ```

Run this in Rstudio console run this
```r
  setwd("path/to/hds-practical")
  renv::restore()
```
If R asks "It looks like you've called renv::restore() in a project that
hasn't been activated yet", choose option `1`.


## How this Repo was built

## Python Setup 

1. First create a place in the hds-practical directory for Lab 1 and move scripts to the directory in terminal

```bash
cd ~/Desktop/hds-practical #change directory to hds-practical
mkdir -p scripts data #make directory for scripts and data
mv patients.csv data/ #moving data
mv patients_by_age.csv data/
echo "*.log" > .gitignore
echo "secrets.txt" >> .gitignore
echo "__pycache__/" >> .gitignore
echo ".venv/" >> .gitignore
echo "renv/library/" >> .gitignore
echo "# AI usage" > AI_USAGE.md
```
2. Create python analysis script 
```bash
cat > scripts/analyze.py << 'PYEOF'
import pandas as pd
df = pd.read_csv("data/patients.csv")
print(df.describe())
PYEOF
```
script reads patients.csv and prints summary stats

3. create enviornment, activate it, run script, and export enviornment file 
```bash
conda create -n hds-practical python=3.12 pandas=2.2 -y
conda activate hds-practical
python scripts/analyze.py
conda env export --from-history > environment.yml
cat environment.yml
```
4. reproducibility test
```bash
conda deactivate
conda env remove -n hds-practical -y
conda env create -f environment.yml
conda activate hds-practical
python scripts/analyze.py
```
this deletes the enviornment, recreates it fron enviornment.yml only and reruns the scriptand checks to see if outputs match

5. Confirm enviornment is registered with conda
```bash
conda info --envs
```
## Setup for Renv in R
 1. Create R analysis script
```bash
cat > scripts/analyze.R << 'REOF'
library(dplyr)
df <- read.csv("data/patients.csv")
print(summary(df))
REOF
```

2.In R Console
```R
setwd("~/Desktop/hds-practical")
renv::init()
source("scripts/analyze.R")
renv::snapshot()
```
3. Reproducibilty test 
```R
renv::deactivate()
unlink("renv/library", recursive = TRUE)
renv::activate()
renv::restore()
source("scripts/analyze.R")
```
# R enviornment vs Python Environment setup 
I personally preferred to us renv over conda since I have more of a familiarity with R over python,
however I can see how using conda or mamba will be useful in the future. This is because conda/mamba
is better multi-language projects or system-level dependencies. Also important to note to not use conda 
and mamba at the same time if they are in different directories.

## Docker Setup to  containerize
1. Write the Dockerfile 
```bash
cat > Dockerfile << 'DOCKEREOF'
FROM condaforge/miniforge3:latest
WORKDIR /workspace
COPY environment.yml .
RUN mamba env create -f environment.yml && mamba clean -afy
COPY scripts/ scripts/
COPY data/ data/
CMD ["conda", "run", "--no-capture-output", "-n", "hds-practical", "python", "scripts/analyze.py"]
DOCKEREOF
```
2. Build image and run it
```bash
docker build -t hds-practical .
docker run --rm hds-practical
```
3. Confirm container output matches native run
```bash
conda activate hds-practical
python scripts/analyze.py > native_output.txt
docker run --rm hds-practical > docker_output.txt
diff native_output.txt docker_output.txt
rm native_output.txt docker_output.txt
```


