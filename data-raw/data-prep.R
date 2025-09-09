# check for installed packages ----

IP <- installed.packages()
URL <- c(
  ADNI = 'https://ida.loni.usc.edu/',
  A4LEARN = 'https://www.a4studydata.org/'
)

stop("ADNIMERGE2 and A4LEARN are not installed. ADNIMERGE2 can be optained from ",
  URL['ADNI'], ". A4LEARN can be obtained from ", URL['A4LEARN'], ".")

if(!"ADNIMERGE2" %in% IP & !"A4LEARN" %in% IP){
  stop("ADNIMERGE2 and A4LEARN are not installed. ADNIMERGE2 can be optained from ",
    URL['ADNI'], ". A4LEARN can be obtained from ", URL['A4LEARN'], ".")
}

if(!"ADNIMERGE2" %in% IP){
  stop("ADNIMERGE2 is not installed. ADNIMERGE2 can be optained from ",
    URL['ADNI'], ".")
}

if(!"A4LEARN" %in% IP){
  stop("A4LEARN is not installed. A4LEARN can be obtained from ",
    URL['A4LEARN'], ".")
}
