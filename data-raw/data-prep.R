library(labelled)
library(dplyr)
# check for installed packages ----

IP <- installed.packages()
URL <- c(
  ADNI = 'https://ida.loni.usc.edu/',
  A4LEARN = 'https://www.a4studydata.org/'
)

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

# ADSL ----

AL_ADSL <- A4LEARN::SUBJINFO %>%
  rename(STUDYID = SUBSTUDY, SUBJID = BID, TRT = TX, AGE = AGEYR, MARISTAT = MARITAL,
    EDUC = EDCCNTU, BMI = BMIBL, MMSCORE = MMSETSV6, DIGITSCR = COGDSSTTSV6,
    LDELTOTL = COGLMDRTSV6, APOE = APOEGN) %>%
  mutate(
    USUBJID = paste0(STUDYID, '-', SUBJID),
    AGEU = "Years"
  )

ADSL <- ADNIMERGE2::ADSL %>%
  bind_rows(AL_ADSL)

for(cc in colnames(ADNIMERGE2::ADSL)){
  var_label(ADSL[,cc]) <- get_variable_labels(ADNIMERGE2::ADSL)[[cc]]
}

for(cc in setdiff(colnames(ADSL), colnames(ADNIMERGE2::ADSL))){
  var_label(ADSL[,cc]) <- A4LEARN::derived_datadic %>%
    filter(FILE_NAME == 'SUBJINFO.csv' & FIELD_NAME == cc) %>%
    pull(FIELD_DESC)
}

usethis::use_data(ADSL, overwrite = TRUE)

# ADQS ----

AL_ADQS <- A4LEARN::ADQS %>%
  select(STUDYID = SUBSTUDY, SUBJID = BID,
    ADY = QSDTC_DAYS_T0, PARAM = QSTEST, PARAMCD = QSTESTCD, AVAL = QSSTRESN,
    BASE = QSBLRES, CHG = QSCHANGE, QSSEQ) %>%
  mutate(
    USUBJID = paste0(STUDYID, '-', SUBJID),
    AVALC = as.character(AVAL),
    PCHG = (AVAL - BASE)/BASE * 100) %>%
  left_join(AL_ADSL, by = join_by(STUDYID, USUBJID, SUBJID))

ADQS <- ADNIMERGE2::ADQS %>%
  bind_rows(AL_ADQS) %>%
  mutate(
    PARAMCD = case_when(
      PARAMCD == "MMSCORE" ~ 'MMSE',
      TRUE ~ PARAMCD),
    PARAM = case_when(
      PARAM == 'Clinical Dementia Rating Sum of Boxes' ~
        'CDR Sum of Boxes',
      PARAM == 'Clinical Dementia Rating Global Score' ~
        'CDR Global',
      PARAM == 'Digit Symbol Substitution Test' ~
        'Digit Symbol Substitution',
      TRUE ~ PARAM))

for(cc in intersect(colnames(ADQS), colnames(ADNIMERGE2::ADQS))){
  var_label(ADQS[,cc]) <- get_variable_labels(ADNIMERGE2::ADQS)[[cc]]
}

for(cc in setdiff(colnames(ADQS), colnames(ADNIMERGE2::ADQS))){
  var_label(ADQS[,cc]) <- A4LEARN::derived_datadic %>%
    filter(FILE_NAME == 'SUBJINFO.csv' & FIELD_NAME == cc) %>%
    pull(FIELD_DESC)
}

usethis::use_data(ADQS, overwrite = TRUE)
