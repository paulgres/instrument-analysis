# instrument-analysis
# Project Name: instrument-analysis

## Description:
instrument-analysis is planned to evolve into a comprehensive collection of subprograms designed to enable statistical and stochastic analysis of exchange-traded instruments, including stocks, bonds, derivatives, and composite indices. This open-source project provides a powerful toolkit for quantitative analysts, financial researchers, and traders to gain insights into the behavior and performance of various financial instruments.

## Planned Features:
1. **Data Acquisition and Preprocessing:** The project offers robust functionality to acquire and preprocess historical data from diverse sources, ensuring accurate and reliable analysis.

2. **Statistical Analysis:** instrument-analysis includes a wide range of statistical techniques to analyze financial instruments. Users can explore descriptive statistics, measure central tendency and dispersion, identify outliers, calculate correlations, and perform regression analysis.

3. **Stochastic Analysis:** The project incorporates stochastic modeling techniques, allowing users to simulate and analyze the probabilistic behavior of financial instruments. It supports Monte Carlo simulations, stochastic differential equations, and other advanced stochastic models to forecast prices, estimate risks, and simulate potential scenarios.

4. **Visualization Tools:** instrument-analysis provides intuitive and interactive visualization tools to present analysis results effectively. Users can generate various types of charts, including line graphs, bar charts, scatter plots, histograms, and heatmaps, to enhance the interpretation and communication of findings.

5. **Portfolio Analysis:** The project includes capabilities to analyze investment portfolios by assessing risk-return profiles, optimizing asset allocation strategies, and conducting performance attribution analysis.

6. **Backtesting and Strategy Evaluation:** Users can evaluate investment strategies and trading algorithms by performing rigorous backtesting using historical data. This feature enables them to assess the viability and profitability of different trading strategies.

7. **Extensibility and Integration:** The project is built with extensibility in mind, providing a modular architecture that allows users to incorporate their own models, algorithms, and data sources. It also supports integration with popular data analysis and machine learning libraries, enabling seamless workflow integration.

8. **Documentation and Examples:** instrument-analysis includes comprehensive documentation and example codes that facilitate quick adoption and assist users in understanding the functionalities and best practices of the library.

We welcome contributions from the open-source community, including bug fixes, new features, and enhancements. Together, we aim to build an inclusive and collaborative platform that empowers financial analysis and research.

## Implementation Details:
- **Data Acquisition and Preprocessing:** Python will be used to implement the data acquisition and pre-processing components.
- **Statistical Analysis and Stochastic Analysis:** Most of the heavy lifting for numerical analysis will be implemented in Fortran to ensure efficient computations.
- **Visualization Tools:** Python, along with libraries such as Matplotlib, will be used to implement the graphing and charting components.
- **Portfolio Analysis:** Fortran will be used for efficient numerical computations in the portfolio analysis subprograms.
- **Backtesting and Strategy Evaluation:** Both Python and Fortran will be utilized, depending on the specific tasks involved.


## Dependencies:
- Python 3.x
- NumPy
- Pandas
- Matplotlib
- SciPy
- We will most certainly use a BLAS implementation for efficient matrix manipulation. 

## License: MIT License

## Build:
Compiles with Fortran Package Manager (fpm) and gfortran


## Components:

**idxstats**: Computes moving average statistics of stock market indices.

Usage: Run `../bin/idxstats xyz1 xyz2 ..` in the `data` directory. Replace `xyzN` with the name of the index file (without extension) containing a matrix of historical prices for each index constituent ordered by time.

Accepted input file types: .txt (fixed width) and .csv.

For .txt files: Ensure that the headers do not contain spaces, as this can affect the estimation of the number of columns. The file should have a fixed width format with a date column of width 10, followed by 20 columns for each constituent's price.

Example command for running the program: `../bin/idxstats index1 index2`

The program computes the number of constituents that have exited above their respective moving average on each given date.

Example if input file:
| DATE       | AGFS_UW            | APDN_UR            | ANIK_UW            | ADXS_UW            |
|------------|--------------------|--------------------|--------------------|--------------------|
| 2016-01-04 | 6.280000209808E+00 | 1.244000015259E+02 | 3.808000183105E+01 | 1.411499938965E+02 |
| 2016-01-05 | 6.300000190735E+00 | 1.288000030518E+02 | 3.858000183105E+01 | 1.438500061035E+02 |
| 2016-01-06 | 6.010000228882E+00 | 1.255999984741E+02 | 3.738000106812E+01 | 1.294499969482E+02 |
| 2016-01-07 | 5.920000076294E+00 | 1.195999984741E+02 | 3.677999877930E+01 | 1.213499984741E+02 |
| 2016-01-08 | 6.059999942780E+00 | 1.191999969482E+02 | 3.683000183105E+01 | 1.190999984741E+02 |
| 2016-01-11 | 5.820000171661E+00 | 1.164000015259E+02 | 3.681999969482E+01 | 1.119000015259E+02 |
| 2016-01-12 | 5.760000228882E+00 | 1.120000000000E+02 | 3.788999938965E+01 | 1.234499969482E+02 |
| 2016-01-13 | 5.989999771118E+00 | 1.064000015259E+02 | 3.675000000000E+01 | 1.155000000000E+02 |
| 2016-01-14 | 6.000000000000E+00 | 1.180000000000E+02 | 3.768000030518E+01 | 1.136999969482E+02 |
| 2016-01-15 | 6.000000000000E+00 | 1.160000000000E+02 | 3.809999847412E+01 | 1.090500030518E+02 |
| 2016-01-19 | 5.940000057220E+00 | 1.184000015259E+02 | 3.700000000000E+01 | 1.036500015259E+02 |

Example of output file `xyzN_res.txt`:
| DATE       | R50                | R100               | R200               |
|------------|--------------------|--------------------|--------------------|
| 2016-01-04 | NaN                | NaN                | NaN                |
| ...        | ...                | ...                | ...                |
| 2016-03-14 | NaN                | NaN                | NaN                |
| 2016-03-15 | 6.314015984535E-01 | NaN                | NaN                |
| ...        | ...                | ...                | ...                |
| 2016-05-24 | 5.482758879662E-01 | NaN                | NaN                |
| 2016-05-25 | 5.534482598305E-01 | 6.576763391495E-01 | NaN                |
| ...        | ...                | ...                | ...                |
| 2016-10-14 | 3.869014978409E-01 | 5.245901346207E-01 | NaN                |
| 2016-10-17 | 3.690869212151E-01 | 5.107344388962E-01 | 6.182719469070E-01 |
| 2016-10-18 | 3.980208933353E-01 | 5.231638550758E-01 | 6.237077713013E-01 |
| 2016-10-19 | 4.079164266586E-01 | 5.231638550758E-01 | 6.239837408066E-01 |
| 2016-10-20 | 4.074684381485E-01 | 5.220338702202E-01 | 6.118904352188E-01 |

Currently uses hard coded moving average windows of 50, 100 and 200 trading days.
