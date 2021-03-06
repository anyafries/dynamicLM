% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot_dynamic_HR.R
\name{plot_dynamic_HR}
\alias{plot_dynamic_HR}
\title{Plots the dynamic hazard ratio of a cox or CSC supermodel}
\usage{
plot_dynamic_HR(
  supermodel,
  covars,
  CI = T,
  cause,
  end_time,
  extend = F,
  silence = F,
  xlab = "LM time",
  ylab,
  ylim,
  main,
  logHR = T,
  ...
)
}
\arguments{
\item{supermodel}{An object of class "LMcoxph" or "LMCSC", i.e. a fitted supermodel}

\item{covars}{Vector or list of strings indicating the variables to plot the HR of
(note these must be given without time interaction label, for e.g., as in LMcovars).}

\item{CI}{Include confidence intervals or not, default is TRUE}

\item{cause}{Cause of interest if considering competing risks}

\item{end_time}{Final time point to plot HR, defaults to the last landmark point used in model fitting.}

\item{extend}{Argument to allow for HR to be plot at landmark times that are later than the LMs used in model fitting.
Default is FALSE. If set to TRUE, the HR may be unreliable.}

\item{silence}{silence the warning message when end_time > LMs used in fitting the model}

\item{xlab}{x label for the plots}

\item{ylab}{y label for the plots}

\item{ylim}{y limit for the plots}

\item{main}{Vector of strings indicating the title of each plot. Must be in the same order as covars.}

\item{logHR}{Boolean, if true plots the log of the hazard ratio, if false plots the hazard ratio}

\item{...}{Additional arguments passed to plot}
}
\value{
Plots for each variable in covars showing the dynamic hazard ratio
}
\description{
Plots the dynamic hazard ratio of a cox or CSC supermodel
}
\details{
See the Github for example code
}
