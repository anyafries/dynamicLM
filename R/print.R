#' Print function for object of class LM.data.frame
#'
#' @param x Object of class LMpred
#' @param ... Arguments passed to print.
#'
#' @return Printed output.
#' @export
#'
print.LMpred <- function(x, ...){
  cat("$preds\n")
  print(utils::head(x$preds))
  if(nrow(x$preds) > 5) cat(paste0(" [ omitted ",nrow(x$preds)-5," rows ]\n"))
  cat("\n")

  cat("$w\n")
  print(x$w)
  cat("\n")

  cat("$type\n")
  print(x$type)
  cat("\n")

  cat("$LHS\n")
  print(x$LHS)
  cat("\n")

  cat("$data\n")
  print(utils::head(x$data))
  if(nrow(x$data) > 5) cat(paste0(" [ omitted ",nrow(x$data)-5," rows ]\n"))
  cat("\n")

  cat("$cause\n")
  print(x$cause)
  cat("\n")
}

#' Print function for object of class LMdataframe
#'
#' @param x Object of class LMdataframe
#' @param ... Arguments passed to print.
#'
#' @return Printed output.
#' @export
#'
print.LMdataframe <- function(x, ...){
  if (!requireNamespace("data.table", quietly = TRUE)) {
    stop("Package \"data.table\" must be installed to use function LMScore.", call. = FALSE)}

  cat("$LMdata\n")
  print(utils::head(x$LMdata))
  if(nrow(x$LMdata) > 5) cat(paste0(" [ omitted ",nrow(x$LMdata)-5," rows ]\n"))
  cat("\n")
  cat("\n")

  cat("$outcome\n")
  names.outcome = names(x$outcome)
  for (i in 1:length(x$outcome)){
    if (is.null(names.outcome[i])) label <- paste0("[[",i,"]]")
    else label <- paste0("$",names.outcome[i])
    cat(paste0("$outcome",label,"\n"))
    print(x$outcome[[i]])
    cat("\n")
  }

  cat("$w\n")
  print(x$w)
  cat("\n")

  cat("$end_time\n")
  print(x$end_time)
  cat("\n")

  names.LMdata = names(x)

  if("func_covars" %in% names.LMdata){
    cat("$func_covars\n")
    names.fc = names(x$func_covars)
    for (i in 1:length(x$func_covars)){
      if (is.null(names.fc[i])) label <- paste0("[[",i,"]]")
      else paste0("$",names.fc[i])
      cat(paste0("$func_covars$",label,"\n"))
      print(x$func_covars[[i]])
      cat("\n")
    }
  }
  if("func_LMs" %in% names.LMdata){
    cat("$func_LMs\n")
    names.fc = names(x$func_LMs)
    for (i in 1:length(x$func_LMs)){
      if (is.null(names.fc[i])) label <- paste0("[[",i,"]]")
      else paste0("$",names.fc[i])
      cat(paste0("$func_LMs$",label,"\n"))
      print(x$func_LMs[[i]])
      cat("\n")
    }
  }
  if("LMcovars" %in% names.LMdata){
    cat("$LMcovars\n")
    print(x$LMcovars)
    cat("\n")
  }
  if("allLMcovars" %in% names.LMdata){
    cat("$allLMcovars\n")
    print(x$allLMcovars)
    cat("\n")
  }
  if("LM_col" %in% names.LMdata){
    cat("$LM_col\n")
    print(x$LM_col)
    cat("\n")
  }
}

#' Print function for object of class LMScore
#'
#' @param x Object of class LMScore
#' @param digits Number of significant digits to include
#' @param ... Arguments passed to print.
#'
#' @importFrom data.table :=
#'
#' @return Printed output.
#' @export
#'
print.LMScore <- function(x,digits=3,...){

  if(nrow(x$auct)>0){
    cat(paste0("\nMetric: Time-dependent AUC for ",x$w,"-",x$unit," risk prediction\n"))
    cat("\nResults by model:\n")

    AUC=se=times=lower=upper=NULL
    fmt <- paste0("%1.",digits[[1]],"f")
    X <- data.table::copy(x$auct)
    X[,AUC:=sprintf(fmt=fmt,100*AUC)]
    if (match("se",colnames(X),nomatch=0)) X[,se:=NULL]
    if (match("times",colnames(X),nomatch=0)) X[,times:=NULL]
    if (match("lower",colnames(X),nomatch=0)) X[,lower:=sprintf(fmt=fmt,100*lower)]
    if (match("upper",colnames(X),nomatch=0)) X[,upper:=sprintf(fmt=fmt,100*upper)]

    print(X,digits=digits)

    # cat("\nResults by comparison: \nTODO\n")

    message("NOTE: Values are multiplied by 100 and given in %.")
    message("NOTE: The higher AUC the better.")
    message(paste0("NOTE: Predictions are made at time tLM for ",x$w,"-year risk"))
  }
  if(nrow(x$briert)>0){
    cat(paste0("\nMetric: Brier Score for ",x$w,"-",x$unit," risk prediction\n"))
    cat("\nResults by model:\n")

    Brier=se=times=se.conservative=lower=upper=NULL
    fmt <- paste0("%1.",digits[[1]],"f")
    X <- data.table::copy(x$briert)
    X[,Brier:=sprintf(fmt=fmt,100*Brier)]
    if (match("se",colnames(X),nomatch=0)) X[,se:=NULL]
    if (match("times",colnames(X),nomatch=0)) X[,times:=NULL]
    if (match("se.conservative",colnames(X),nomatch=0)) X[,se.conservative:=NULL]
    if (match("lower",colnames(X),nomatch=0)) X[,lower:=sprintf(fmt=fmt,100*lower)]
    if (match("upper",colnames(X),nomatch=0)) X[,upper:=sprintf(fmt=fmt,100*upper)]
    print(X)

    # cat("\nResults by comparison: \nTODO\n")

    message("NOTE: Values are multiplied by 100 and given in %.")
    message("NOTE: The lower Brier the better.")
    message(paste0("NOTE: Predictions are made at time tLM for ",x$w,"-year risk"))
  }
}

#' Print function for object of class LMCSC
#'
#' @param x Object of class LMCSC
#' @param ... Arguments passed to print.
#'
#' @return Printed output.
#' @export
#'
print.LMCSC <- function(x, ...) {
  cat(paste0("\nLandmark cause-specific cox super model fit for dynamic ",x$w,"-year prediction:\n\n"))
  cat("$model\n")
  num_causes <- length(x$model$causes)
  for (i in 1:num_causes){
    cat(paste0("----------> Cause: ",i,"\n"))
    cox_model = x$model$models[[i]]
    cox_model$call = NULL
    print(cox_model)
    cat("\n\n")
  }

  cat("$func_covars\n")
  names.fc = names(x$func_covars)
  for (i in 1:length(x$func_covars)){
    if (is.null(names.fc[i])) label <- paste0("[[",i,"]]")
    else paste0("$",names.fc[i])
    cat(paste0("$func_covars$",label,"\n"))
    print(x$func_covars[[i]])
    cat("\n")
  }
  cat("$func_LMs\n")
  names.fc = names(x$func_LMs)
  for (i in 1:length(x$func_LMs)){
    if (is.null(names.fc[i])) label <- paste0("[[",i,"]]")
    else paste0("$",names.fc[i])
    cat(paste0("$func_LMs$",label,"\n"))
    print(x$func_LMs[[i]])
    cat("\n")
  }

  cat("$w\n")
  print(x$w)
  cat("\n")

  cat("$end_time\n")
  print(x$end_time)
  cat("\n")

  cat("$type\n")
  print(x$type)
  cat("\n")

}


#' Print function for object of class LMcoxph
#'
#' @param x Object of class LMcoxph
#' @param ... Arguments passed to print.
#'
#' @return Printed output.
#' @export
#'
print.LMcoxph <- function(x, ...) {
  cat(paste0("\nLandmark cox super model fit for dynamic ",x$w,"-year prediction:\n\n"))
  cat("$model\n")

  cox_model = x$model
  cox_model$call = NULL
  print(cox_model)
  cat("\n\n")

  cat("$func_covars\n")
  names.fc = names(x$func_covars)
  for (i in 1:length(x$func_covars)){
    if (is.null(names.fc[i])) label <- paste0("[[",i,"]]")
    else paste0("$",names.fc[i])
    cat(paste0("$func_covars$",label,"\n"))
    print(x$func_covars[[i]])
    cat("\n")
  }
  cat("$func_LMs\n")
  names.fc = names(x$func_LMs)
  for (i in 1:length(x$func_LMs)){
    if (is.null(names.fc[i])) label <- paste0("[[",i,"]]")
    else paste0("$",names.fc[i])
    cat(paste0("$func_LMs$",label,"\n"))
    print(x$func_LMs[[i]])
    cat("\n")
  }

  cat("$w\n")
  print(x$w)
  cat("\n")

  cat("$end_time\n")
  print(x$end_time)
  cat("\n")

  cat("$type\n")
  print(x$type)
  cat("\n")

}
