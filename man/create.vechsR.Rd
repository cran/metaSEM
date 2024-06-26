\name{create.vechsR}
\alias{create.vechsR}
\title{Create a model implied correlation matrix with implicit diagonal constraints
}
\description{It creates implicit diagonal constraints on the model
  implied correlation matrix by treating the error variances as
  functions of other parameters. 
}
\usage{
create.vechsR(A0, S0, F0 = NULL, Ax = NULL, Sx = NULL, A.lbound=NULL, A.ubound=NULL)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
\item{A0}{A Amatrix, which will be converted into \code{MxMatrix-class} via \code{as.mxMatrix}.}
\item{S0}{A Smatrix, which will be converted into \code{MxMatrix-class} via \code{as.mxMatrix}.}
\item{F0}{A Fmatrix, which will be converted into \code{MxMatrix-class} via \code{as.mxMatrix}.}
\item{Ax}{A Amatrix of a list of Amatrix with definition variables as the moderators of the Amatrix.}
\item{Sx}{A Smatrix of a list of Smatrix with definition variables as the moderators of the Smatrix.}
\item{A.lbound}{A matrix of lower bound of the Amatrix. If a scalar is
  given, the lbound matrix will be filled with this scalar.}
\item{A.ubound}{A matrix of upper bound of the Amatrix. If a scalar is
  given, the ubound matrix will be filled with this scalar.}
}

\value{A list of \code{MxMatrix-class}. The model implied correlation
  matrix is computed in \code{impliedR} and \code{vechsR}.}
\note{Since \code{A0} are the intercepts and \code{Ax} are the
  regression coefficients. The parameters in \code{Ax} must be a subset of those in
  \code{A0}.}
\author{Mike W.-L. Cheung <mikewlcheung@nus.edu.sg>
}
\seealso{ \code{\link[metaSEM]{osmasem}},
  \code{\link[metaSEM]{create.Tau2}}, \code{\link[metaSEM]{create.V}}
}

\examples{
\donttest{
## Proposed model
model1 <- 'W2 ~ w2w*W1 + s2w*S1
           S2 ~ w2s*W1 + s2s*S1
           W1 ~~ w1WITHs1*S1
           W2 ~~ w2WITHs2*S2
           W1 ~~ 1*W1
           S1 ~~ 1*S1
           W2 ~~ Errw2*W2
           S2 ~~ Errs2*S2'

## Convert into RAM    
RAM1 <- lavaan2RAM(model1, obs.variables=c("W1", "S1", "W2", "S2"))

## No moderator    
M0 <- create.vechsR(A0=RAM1$A, S0=RAM1$S, F0=NULL, Ax=NULL, Sx=NULL)

## Lag (definition variable) as a moderator on the paths in the Amatrix    
Ax <- matrix(c(0,0,0,0,
               0,0,0,0,
               "0*data.Lag","0*data.Lag",0,0,
               "0*data.Lag","0*data.Lag",0,0),
             nrow=4, ncol=4, byrow=TRUE)
                
M1 <- create.vechsR(A0=RAM1$A, S0=RAM1$S, F0=NULL, Ax=Ax, Sx=NULL)    

## Lag (definition variable) as a moderator on the correlation in the Smatrix
Sx <- matrix(c(0,"0*data.Lag",0,0,
               "0*data.Lag",0,0,0,
               0,0,0,"0*data.Lag",
               0,0,"0*data.Lag",0),
             nrow=4, ncol=4, byrow=TRUE)

M2 <- create.vechsR(A0=RAM1$A, S0=RAM1$S, F0=NULL, Ax=NULL, Sx=Sx)
}
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ osmasem }
