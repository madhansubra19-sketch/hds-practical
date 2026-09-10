FROM condaforge/miniforge3:latest
WORKDIR /workspace
COPY environment.yml .
RUN mamba env create -f environment.yml && mamba clean -afy
COPY scripts/ scripts/
COPY data/ data/
CMD ["conda", "run", "--no-capture-output", "-n", "hds-practical", "python", "scripts/analyze.py"]
