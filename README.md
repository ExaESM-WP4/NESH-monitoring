# NESH monitoring

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/ExaESM-WP4/NESH-monitoring/master?urlpath=lab/tree/analysis.ipynb)

Collects log files to get a quantitative overview of the idle CPU and free memory resources of the NEC Linux cluster operated by the University of Kiel, which are those resources that are readily (and without competing with the classical batch job tasks) available for interactive computing workflows with Dask.
Project was inspired by the development of machine specific Dask jobqueue configuration defaults which are [available here](https://github.com/ExaESM-WP4/Dask-jobqueue-configs).
