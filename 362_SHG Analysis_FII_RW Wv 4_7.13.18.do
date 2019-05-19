
/*---------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	: This do.file was developed by the Evans School Policy Analysis & Research Group (EPAR) 
				  for the construction of indicators related to Coverage and Characteristics of Self-Help Groups using the
				  Rwanda Financial Inclusion Insights (FII) survey (2014-2015) 												
*Author(s)		: Pierre Biscaye, Kirby Callaway, Elan Ebeling, Annie Rose Favreau, Mel Howlett, 
				  Daniel Lunchik-Seymour, Emily Morton, Kels Phelps,
				  C. Leigh Anderson & Travis Reynolds

				*Acknowledgments: We acknowledge the helpful contributions of members of the Bill & Melinda Gates Foundation Gender Equality team in 
				 discussing indicator construction decisions. All coding errors remain ours alone.

*Date			: 13 July 2018
----------------------------------------------------------------------------------------------------------------------------------------------------*/

*Data source
*-----------
*The Rwanda Financial Inclusion Insights survey was collected by InterMedia 
*over the period December 2014 - February 2015.
*All the raw data, questionnaires, and basic information documents are available upon request from the 
*InterMedia website: http://finclusion.org/

*Summary of executing the Master do.file
*-----------
*This master do file constructs selected indicators using the Rwanda FII data set.
*Using a data file from within the "Raw Data" folder within the "FII" folder, 
*the do-file constructs relevant indicators related to Self-Help Group coverage
*and Use and saves final dta files with all created variables and indicators
*in the "Created Data" folder within the "FII" folder.
*Additionally, the do-file creates Excel spreadsheet with estimates of coverage 
*and characteristic indicators disaggregated by gender, mobile phone access,
*bank account access, urban vs. rural, possession of official identification,
*poverty level, and mobile money use.
*These estimates are saved in the "Outputs" folder with in the "FII" folder.
*Throughought the do-file we refer to "Self-Help Groups" as "SHGs".

*The following refer to running this Master do.file with EPAR's cleaned data files. Information on EPAR's cleaning and construction decisions is available in the 
*"EPAR_UW_362_SHG_Indicator_CrossComparisons" spreadsheet. 

clear
set more off

//Set directories
*Rwanda FII Survey Wave 4

global RW_FIIW4_data 							"FII/Raw Data"
global created_data 							"FII/Created Data"
global final_data 								"FII/Outputs"

************
*CLEAN DATA
************
use "$RW_FIIW4_data\Rwanda Wave 4 Stata.dta", clear
keep Serial gender DG5* AA7 poverty ppi* UR /* relevant demographic data
*/ MT1 MT3 MT10 MT15 /* Mobile phone ownership
*/ FF1 FF4 FF14_22 /* Bank use
*/ MM2* MM4* MM15_22 /* Mobile money use
*/ IFI1_* IFI18 IFI3_* /* Savings group membership/account
*/ IFI2* /* frequency
*/ IFI5* /* SHG provide 'loan only'?
*/ IFI7* IFI8* /* mobile services
*/ IFI11* IFI12* /*  financial transactions 
*/ IFI22* /* negative experience
*/ IFI24 /* reason do not belong to savings group 
*/ FL4 /* advice
*/ FB16* /* borrowed ever
*/ FB16A* /* current loan
*/ FB22* /* do you save?
*/ FB17* FB23* /* interest rate knowledge
*/ weight // weights


***********
*RENAME VARIABLES
***********
*Demographics
ren ur urban_rural
*Segmentation
ren MT1 phone_ownership
ren MT3 phone_access
ren FF1 bank_ownership
*Mobile Money
ren MM2_1 aware_MTN
ren MM2_2 aware_airtel
ren MM2_3 aware_tigocash
ren MM2_4 aware_other
ren MM5_1 use_MTN
ren MM5_2 use_airtel
ren MM5_3 use_tigocash
ren MM5_4 use_other

*Official ID
ren DG5_1 id_gov
ren DG5_2 id_passport
ren DG5_3 id_driver
ren DG5_5 id_employee
ren DG5_6 id_military
ren DG5_7 id_birthcert
ren DG5_8 id_other

*Self-reported use
ren IFI1_1 use_MFI
ren IFI1_2 use_nonumu_SACCO
ren IFI1_3 use_umu_SACCO
ren IFI1_4 use_coopvsla
ren IFI1_5 use_moneyguard
ren IFI1_6 use_savcollector
ren IFI1_7 use_familymember
ren IFI1_8 use_digicard
ren IFI1_9 use_otherfinserv

*Financial Services
ren FL10_5 loan_inform_finserv
ren FL13_4 sav_inform_finserv
ren IFI3_2 acct_nonumu_SACCO
ren IFI3_3 acct_umu_SACCO

*Characteristics
ren IFI7_1 non_umu_debit
ren IFI7_2 non_umu_app
ren IFI7_3 non_umu_transfer
ren IFI8_1 umu_debit
ren IFI8_2 umu_app
ren IFI8_3 umu_transfer
ren FL11_5 int_rt_loan_inform
ren FL14_4 int_rt_sav_inform
ren IFI2_2 recent_nonumu_SACCO
ren IFI2_3 recent_umu_SACCO
ren IFI2_5 recent_coopvsla
ren IFI5_2 loan_only_nonumu_SACCO //reponse option 2 is "only loans and no other services"
ren IFI5_3 loan_only_umu_SACCO
ren TS1_8 trust_nonumu_SACCO
ren TS1_9 trust_umu_SACCO
ren TS1_12 trust_coopvsla

gen loan = . 
replace loan = 0 if loan_only_nonumu_SACCO==5 | loan_only_nonumu_SACCO==5
replace loan = 1 if loan_only_nonumu_SACCO<=4 | loan_only_nonumu_SACCO<=4

************************
*SET WEIGHTS
************************
svyset [pweight=weight]

************
*SEGMENTATION 
************
*Rural
gen rural = .
lab var rural "1 = Rural"
replace rural = 0 if urban_rural == 1
replace rural = 1 if urban_rural == 2
//n=2,003

*Poverty: //No Equivalent poverty indicator in Rwanda FII

*Gender
gen female = .
lab var female "1 = Female"
replace female = 1 if gender==2
replace female = 0 if gender==1
//n=2,003

*Mobile phone and bank ownership and access
gen phone_own = .
lab var phone_own "Individual owns or has access to a mobile phone"
replace phone_own = 0 if phone_ownership == 2 | phone_access == 2
replace phone_own = 1 if phone_ownership == 1 | phone_access == 1
//n=2,003

**Bank Account
gen bank_own = .
lab var bank_own "Individual has bank account registered in their name"
replace bank_own = 0 if bank_ownership == 2
replace bank_own = 1 if bank_ownership == 1 
//n=2,003

**EVER USED MOBILE MONEY
gen MM_use = 0
lab var MM_use "Individual has used Mobile Money for any financial activity"
replace MM_use = 1 if use_MTN==1 | use_airtel==1 | use_tigocash==1 | use_other==1 
//n = 2,003 - missing data in MM5 questions came from repondents who were not "aware" of any mobile money service providers in MM2 and MM3, replaced these missings with zeros EAM

**OFFICIAL ID
gen official_id = .
lab var official_id "Individual has official identification"
replace official_id = 1 if id_gov==1 | id_passport==1 | id_driver==1 | id_employee==1 | id_military==1 | id_birthcert==1 
replace official_id = 0 if id_gov==2 & id_passport==2 & id_driver==2 & id_employee==2 & id_military==2 & id_birthcert==2 
//n=2,003


************
**COVERAGE
************

************ 
*PROPORTION OF SHG USERS who receive financial services from SHG
************
*Individuals who have borrowed money from an informal financial service provider
gen inform_finserv_loan = .
lab var inform_finserv_loan "Loan from informal financial service provider / all respondents"
replace inform_finserv_loan = 0 if FL8 == 5 | loan_inform_finserv==2 //FL10_5 = Informal financial service provider such as cooperatives, ESUSU, village savings group
replace inform_finserv_loan = 1 if loan_inform_finserv==1
//n=2,003

*Individuals who have borrowed money from a non-umurenge SACCO
gen nonumu_finserv_loan = .
lab var nonumu_finserv_loan "Loan from non-umurenge SACCO / all respondents"
replace nonumu_finserv_loan = 0 if IFI11_6==2 | use_nonumu_SACCO==2 //IFI11_6 = Take loans, borrow money
replace nonumu_finserv_loan = 1 if IFI11_6==1 & use_nonumu_SACCO==1
//n=2,003

*Individuals who have borrowed money from an umurenge SACCO
gen umu_finserv_loan = .
lab var umu_finserv_loan "Loan from umurenge SACCO / all respondents"
replace umu_finserv_loan = 0 if IFI12_6==2 | use_umu_SACCO==2 //IFI12_6 = Take loans, borrow money
replace umu_finserv_loan = 1 if IFI12_6==1 & use_umu_SACCO==1
//n=2,003

*Individuals who have borrowed money using an SHG
gen SHG_finserv_loan = .
lab var SHG_finserv_loan "Loan from an SHG / all respondents"
replace SHG_finserv_loan = 0 if inform_finserv_loan != . | use_nonumu_SACCO != . | use_umu_SACCO != . 
replace SHG_finserv_loan = 1 if inform_finserv_loan==1 | nonumu_finserv_loan==1 | umu_finserv_loan==1
//n=2,003

*Individuals who have saved money with an informal financial service provider
gen inform_finserv_sav = .
lab var inform_finserv_sav "Save with informal financial service provider / all respondents" 
replace inform_finserv_sav = 0 if sav_inform_finserv==2 //FL13_4 = Informal or semiformal financial organizations such as cooperatives, ESUSU, village savings group
replace inform_finserv_sav = 1 if sav_inform_finserv==1
//n= 2,003 
	
*Individuals who have saved money with a non-umurenge SACCO
gen nonumu_finserv_sav = .
lab var nonumu_finserv_sav "Save with non-umurenge SACCO / all respondents"
replace nonumu_finserv_sav = 0 if IFI11_4==2 | use_nonumu_SACCO==2 //IFI11_4 = Save/store money
replace nonumu_finserv_sav = 1 if IFI11_4==1
//n=2,003

*Individuals who have saved money with an umurenge SACCO
gen umu_finserv_sav = .
lab var umu_finserv_sav "Save with umurenge SACCO / all respondents"
replace umu_finserv_sav = 0 if IFI12_4==2 | use_umu_SACCO==2 //IFI12_4 = Save/store money
replace umu_finserv_sav = 1 if IFI12_4==1
//n=2,003

*Individuals who save money using an SHG
gen SHG_finserv_sav = .
lab var SHG_finserv_sav "Save with an SHG / all respondents"
replace SHG_finserv_sav = 0 if inform_finserv_sav != . | use_nonumu_SACCO != . | use_nonumu_SACCO != . 
replace SHG_finserv_sav = 1 if inform_finserv_sav==1 | nonumu_finserv_sav==1 | umu_finserv_sav==1
//n=2,003

*Individuals who save or borrow with a non-umurenge SACCO
gen nonumu_SACCO_finserv_any = .
lab var nonumu_SACCO_finserv_any "Save or borrow with a SACCO / all respondents"
replace nonumu_SACCO_finserv_any = 0 if nonumu_finserv_sav != . | nonumu_finserv_loan != . 
replace nonumu_SACCO_finserv_any = 1 if nonumu_finserv_sav==1 | nonumu_finserv_loan ==1
//n=2,003

*Individuals who save or borrow with an umurenge SACCO
gen umu_SACCO_finserv_any = .
lab var umu_SACCO_finserv_any "Save or borrow with a SACCO / all respondents"
replace umu_SACCO_finserv_any = 0 if umu_finserv_sav != . | umu_finserv_loan != . 
replace umu_SACCO_finserv_any = 1 if umu_finserv_sav == 1 | umu_finserv_loan ==1
//n=2,003

*Individuals with financial account through Umurenge SACCO
gen umu_SACCO_acct = .
lab var umu_SACCO_acct "Umurenge SACCO - financial account"
replace umu_SACCO_acct = 0 if acct_umu_SACCO==2 //IFI3_3 = Umurenge SACCO account
replace umu_SACCO_acct = 1 if acct_umu_SACCO==1 
//n=2,003

*Individuals with financial account through Non-Umurenge SACCO
gen nonumu_SACCO_acct = .
lab var nonumu_SACCO_acct "Non-Umurenge SACCO - financial account"
replace nonumu_SACCO_acct = 0 if acct_nonumu_SACCO==2 //IFI3_2 = Non-Umurenge SACCO account
replace nonumu_SACCO_acct = 1 if acct_nonumu_SACCO==1 
//n=2,003

*Individuals with financial account through Non-Umurenge SACCO
gen coop_VSLA_acct = .
lab var coop_VSLA_acct "Cooperative/VSLA - financial account"
replace coop_VSLA_acct = 0 if use_coopvsla==2 //IFI1_4 = Cooperative/VSLA account
replace coop_VSLA_acct = 1 if use_coopvsla==1 
//n=2,003

*Individual who used informal financial services for financial services
gen inform_fin_serv = . 
lab var inform_fin_serv "Proportion of individuals who accessed financial services from an informal financial service provider *Among all question respondents)"
replace inform_fin_serv = 0 if inform_finserv_loan == 0 | inform_finserv_sav == 0 
replace inform_fin_serv = 1 if inform_finserv_loan == 1 | inform_finserv_sav == 1 
//n=2,003

*Individual who used SACCOs for financial services
gen SACCO_fin_serv = . 
lab var SACCO_fin_serv "Proportion of individuals who accessed financial services from a SACCO *Among all question respondents)"
replace SACCO_fin_serv = 0 if umu_SACCO_acct == 0 | nonumu_SACCO_acct == 0 | umu_SACCO_finserv_any==0 | nonumu_SACCO_finserv_any
replace SACCO_fin_serv = 1 if umu_SACCO_acct == 1 | nonumu_SACCO_acct == 1 | umu_SACCO_finserv_any==1 | nonumu_SACCO_finserv_any
//n=2,003

*Individuals with financial account with cooperative
gen coop_fin_serv = .
lab var coop_fin_serv "Proportion of individuals who accessed financial services from a cooperative (Among all question respondents)"
replace coop_fin_serv = 0 if coop_VSLA_acct==0
replace coop_fin_serv = 1 if coop_VSLA_acct==1 
//n=2,003

*Individuals who used any SHG for financial services
gen SHG_fin_serv = .
lab var SHG_fin_serv "Proportion of individuals who accessed financial services from a SHG (Among all question respondents)"
replace SHG_fin_serv = 0 if SACCO_fin_serv == 0 | inform_fin_serv == 0 | coop_fin_serv == 0
replace SHG_fin_serv = 1 if SACCO_fin_serv == 1 | inform_fin_serv == 1 | coop_fin_serv == 1
//n=2,003

************
*PROPORTION OF INDIVIDUALS who have used a SHG in any way 
************
*Individuals who report ever using a Cooperative 
gen coop_use_self_report= . 
lab var coop_use_self_report "Individual reports using a cooperative"
replace coop_use_self_report = 0 if use_MFI != . | use_coopvsla != . | use_nonumu_SACCO != . | use_umu_SACCO != . | use_coopvsla | use_moneyguard != . | use_savcollector != . | use_digicard != . | use_otherfinserv != . | use_familymember
replace coop_use_self_report = 1 if use_coopvsla == 1 //IFI1 = have you ever used any of the following. _4 = cooperative/VSLA
//n=2,003

*Individuals who report ever using a SACCO
gen nonumu_SACCO_use_self_report = . 
lab var nonumu_SACCO_use_self_report "Individual reports using a non-umuenge SACCO"
replace nonumu_SACCO_use_self_report = 0 if use_MFI != . | use_coopvsla != . | use_nonumu_SACCO != . | use_umu_SACCO != . | use_coopvsla | use_moneyguard != . | use_savcollector != . | use_digicard != . | use_otherfinserv != . | use_familymember  
replace nonumu_SACCO_use_self_report = 1 if use_nonumu_SACCO == 1 //IFI1 = have you ever used any of the following. _2 = Non-Umurenge SACCO
//n=2,003

*Individuals who report ever using a SACCO
gen umu_SACCO_use_self_report = . 
lab var umu_SACCO_use_self_report "Individual reports using an umurenge SACCO"
replace umu_SACCO_use_self_report = 0 if use_MFI != . | use_coopvsla != . | use_nonumu_SACCO != . | use_umu_SACCO != . | use_coopvsla | use_moneyguard != . | use_savcollector != . | use_digicard != . | use_otherfinserv != . | use_familymember  
replace umu_SACCO_use_self_report = 1 if use_umu_SACCO == 1 //IFI1 = have you ever used any of the following. _3 = Umurenge SACCO
//n=2,003

*Individuals who report ever using any SHG
gen SHG_use_self_report = .
lab var SHG_use_self_report "Individual reports using any SHG"
replace SHG_use_self_report = 0 if coop_use_self_report == 0 | nonumu_SACCO_use_self_report == 0 | umu_SACCO_use_self_report == 0
replace SHG_use_self_report = 1 if coop_use_self_report == 1 | nonumu_SACCO_use_self_report == 1 | umu_SACCO_use_self_report == 1
//n=2,003

*Individuals who have interacted with a SACCO in any way 
gen SACCO_use_any = .
lab var SACCO_use_any "Proportion of individuals who have interacted with a SACCO (Among all question respondents)"
replace SACCO_use_any = 0 if nonumu_SACCO_use_self_report == 0 | umu_SACCO_use_self_report == 0 | SACCO_fin_serv == 0
replace SACCO_use_any = 1 if nonumu_SACCO_use_self_report == 1 | umu_SACCO_use_self_report == 1 | SACCO_fin_serv == 1
//n=2,003

*Individuals who have interacted with a cooperative in any way
gen coop_use_any = .
lab var coop_use_any "Proportion of individuals who have interacted with a cooperative (Among all question respondents)"
replace coop_use_any = 0 if coop_use_self_report == 0 | coop_fin_serv == 0 
replace coop_use_any = 1 if coop_use_self_report == 1 | coop_fin_serv == 1 
//n=2,003

*Individuals who have interacted with a SHG in any way
gen SHG_use_any = .
lab var SHG_use_any "Proportion of individuals who have interacted with a SHG (Among all question respondents)"
replace SHG_use_any = 0 if SACCO_use_any == 0 | coop_use_any == 0 | inform_fin_serv == 0
replace SHG_use_any = 1 if SACCO_use_any == 1 | coop_use_any == 1 | inform_fin_serv == 1
//n=2,003

************
**CHARACTERISTICS
************
************
*PROPORTION OF INDIVIDUALS who belong to SHGs which offer mobile services
************

*Mobile Services available through Non-Umurenge SACCOs.
gen nonumu_SACCO_mobile_serv = . 
lab var nonumu_SACCO_mobile_serv "Proportion of individuals who belong to SACCOs which offer mobile services (Among all question respondents)"
replace nonumu_SACCO_mobile_serv = 0 if use_nonumu_SACCO != .
replace nonumu_SACCO_mobile_serv = 1 if non_umu_debit == 1 | non_umu_app == 1 | non_umu_transfer == 1  //IFI7 = non-umurenge SACCO, _2 = access acct with mobile app or internet, _1 = debit/atm card, _3 = transfer without using cash
//n=2,003

*Mobile Services available through Non-Umurenge SACCOs.
gen umu_SACCO_mobile_serv = . 
lab var umu_SACCO_mobile_serv "Proportion of individuals who belong to SACCOs which offer mobile services (Among all question respondents)"
replace umu_SACCO_mobile_serv = 0 if use_umu_SACCO != .
replace umu_SACCO_mobile_serv = 1 if umu_debit == 1 | umu_app == 1 | umu_transfer == 1  //IFI7 = non-umurenge SACCO, _2 = access acct with mobile app or internet, _1 = debit/atm card, _3 = transfer without using cash
//n=2,003

*Mobile Services available through SHG.
gen SHG_mobile_serv = . 
lab var SHG_mobile_serv "Proportion of individuals who belong to SHGs which offer mobile services (Among all question respondents)"
replace SHG_mobile_serv = 0 if umu_SACCO_mobile_serv == 0 | nonumu_SACCO_mobile_serv == 0
replace SHG_mobile_serv = 1 if umu_SACCO_mobile_serv == 1 | nonumu_SACCO_mobile_serv == 1
//n=2,003

************
*PROPORTION OF INDIVIDUALS who know the interest rate of their SHG loan
************
*Individuals who know the interest rate of their loan with informal financial service providers
gen inform_int_rt_loan = . 
lab var inform_int_rt_loan "Individual knows interest rate of their informal financial service provider loan (Among those who have an informal loan)"
replace inform_int_rt_loan = 0 if int_rt_loan_inform == 2 //informal financial service provider such as cooperatives, ESUSU, village savings groups, etc.
replace inform_int_rt_loan = 1 if int_rt_loan_inform == 1 
//n=136

************
*PROPORTION OF INDIVIDUALS who know the interest rate of their SHG savings account
************
*Individuals who know the interest rate of their savings account with an informal financial service provider
gen inform_int_rt_sav = . 
lab var inform_int_rt_sav "Individual knows interest rate of their informal savings account (Among those who save with an informal account)"
replace inform_int_rt_sav = 0 if int_rt_sav_inform == 2 //FL13_4 = informal financial service provider such as cooperatives, ESUSU, village savings groups, etc.
replace inform_int_rt_sav = 1 if int_rt_sav_inform == 1 
//n=362

************
*PROPORTION OF INDIVIDUALS who know the interest rate of their SHG account
************
*Individuals who know the interest rate of their SHG account
gen SHG_int_rt_any = . 
lab var SHG_int_rt_any "Proportion of individuals who know the interest rate of their SACCO account (Among all account holders)"
replace SHG_int_rt_any = 0 if inform_int_rt_loan == 0 | inform_int_rt_sav == 0
replace SHG_int_rt_any = 1 if inform_int_rt_loan == 1 | inform_int_rt_sav == 1
//n=399

************
*PROPORTION OF INDIVIDUALS who used SHG recently
************
*Individuals who used cooperative in past 30 days
gen coop_use_30days = .
lab var coop_use_30days "Proportion of individuals who have used a cooperative in the past 30 days (Among all question respondents)"
replace coop_use_30days = 0 if recent_coopvsla>3 
replace coop_use_30days = 1 if recent_coopvsla<=3 
//n=2,003

*Individuals who used SACCO in past 30 days
gen nonumu_SACCO_use_30days = .
lab var nonumu_SACCO_use_30days "Proportion of individuals who have used a Non-Umurenge SACCO in the past 30 days (Among all question respondents)"
replace nonumu_SACCO_use_30days = 0 if recent_nonumu_SACCO>3
replace nonumu_SACCO_use_30days = 1 if recent_nonumu_SACCO<=3
//n=2,003

*Individuals who used merry go round in past 30 days
gen umu_SACCO_use_30days = .
lab var umu_SACCO_use_30days "Proportion of individuals who have used an Umurenge SACCO in the past 30 days (Among all question respondents)"
replace umu_SACCO_use_30days = 0 if recent_umu_SACCO>3 
replace umu_SACCO_use_30days = 1 if recent_umu_SACCO<=3
//n=2,003

*Individuals who used any SHG in past 30 days
gen SHG_use_30days = .
lab var SHG_use_30days "Proportion of individuals who have used any SHG in the past 30 days (Among all question respondents)"
replace SHG_use_30days = 0 if coop_use_30days == 0 | nonumu_SACCO_use_30days == 0 | umu_SACCO_use_30days == 0
replace SHG_use_30days = 1 if coop_use_30days == 1 | nonumu_SACCO_use_30days == 1 | umu_SACCO_use_30days == 1
//n=2,003

*Individuals who used cooperative in past 90 days
gen coop_use_90days = .
lab var coop_use_90days "Proportion of individuals who have used a cooperative in the past 90 days (Among all question respondents)"
replace coop_use_90days = 0 if recent_coopvsla>4
replace coop_use_90days = 1 if recent_coopvsla<=4 
//n=2,003

*Individuals who used SACCO in past 90 days
gen nonumu_SACCO_use_90days = .
lab var nonumu_SACCO_use_90days "Proportion of individuals who have used a Non-Umurenge SACCO in the past 90 days (Among all question respondents)"
replace nonumu_SACCO_use_90days = 0 if recent_nonumu_SACCO>4 
replace nonumu_SACCO_use_90days = 1 if recent_nonumu_SACCO<=4 
//n=2,003

*Individuals who used merry go round in past 90 days
gen umu_SACCO_use_90days = .
lab var umu_SACCO_use_90days "Proportion of individuals who have used an Umurenge SACCO go round in the past 90 days (Among all question respondents)"
replace umu_SACCO_use_90days = 0 if recent_umu_SACCO>4 
replace umu_SACCO_use_90days = 1 if recent_umu_SACCO<=4
//n=2,003

*Individuals who used any SHG in past 90 days
gen SHG_use_90days = .
lab var SHG_use_90days "Proportion of individuals who have used any SHG in the past 90 days (Among all question respondents)"
replace SHG_use_90days = 0 if coop_use_90days == 0 | nonumu_SACCO_use_90days == 0 | umu_SACCO_use_90days == 0
replace SHG_use_90days = 1 if coop_use_90days == 1 | nonumu_SACCO_use_90days == 1 | umu_SACCO_use_90days == 1
//n=2,003

************
*PROPORTION OF INDIVIDUALS whose SHG offers only loans
************
*Individuals whose Non-Umurenge SACCO offers "loans only"
gen nonumu_SACCO_loan_only = .
lab var nonumu_SACCO_loan_only "Proportion of individuals who belong to a SACCO which offer only loan services (Among all question respondents)"
replace nonumu_SACCO_loan_only = 0 if use_nonumu_SACCO != . 
replace nonumu_SACCO_loan_only = 1 if loan_only_nonumu_SACCO == 2
//n=2,003

*Individuals whose Umurenge SACCO offers "loans only"
gen umu_SACCO_loan_only = .
lab var umu_SACCO_loan_only "Proportion of individuals who belong to a SACCO which offer only loan services (Among all question respondents)"
replace umu_SACCO_loan_only = 0 if use_umu_SACCO != . 
replace umu_SACCO_loan_only = 1 if loan_only_umu_SACCO == 2
//n=2,003

*Individuals whose SHG (any) offers "loans only"
gen SHG_loan_only = .
lab var SHG_loan_only "Proportion of individuals who belong to any SHG which offer only loan services (Among all question respondents)"
replace SHG_loan_only = 0 if nonumu_SACCO_loan_only == 0 | umu_SACCO_loan_only == 0 
replace SHG_loan_only = 1 if nonumu_SACCO_loan_only == 1 | umu_SACCO_loan_only == 1 
//n=2,003

**Generate Inverse Disaggregator Variables

gen male = .
replace male = 1 if female == 0
replace male = 0 if female ==1

gen urban = .
replace urban = 1 if rural == 0
replace urban = 0 if rural ==1

gen no_MM_use = .
replace no_MM_use = 1 if MM_use == 0
replace no_MM_use = 0 if MM_use ==1

gen no_phone_own = .
replace no_phone_own = 1 if phone_own == 0
replace no_phone_own = 0 if phone_own ==1

gen no_official_id = .
replace no_official_id = 1 if official_id == 0
replace no_official_id = 0 if official_id ==1

gen no_bank_own = .
replace no_bank_own = 1 if bank_own == 0
replace no_bank_own = 0 if bank_own ==1

gen SHG_no_use = .
lab var SHG_no_use "Proportion of individuals who have not interacted with a SHG (Among all question respondents)"
replace SHG_no_use = 0 if SHG_use_any == 1
replace SHG_no_use = 1 if SHG_use_any == 0

*Saving
save "$created_data\RW_FII_final.dta", replace

************
*Disaggregate and Export
************ 
use "$created_data\RW_FII_final.dta", clear

*Create global of characteristic indicators
global char_indicators nonumu_SACCO_mobile_serv umu_SACCO_mobile_serv SHG_mobile_serv inform_int_rt_loan inform_int_rt_sav /*
*/ SHG_int_rt_any coop_use_30days nonumu_SACCO_use_30days umu_SACCO_use_30days SHG_use_30days coop_use_90days nonumu_SACCO_use_90days /*
*/ umu_SACCO_use_90days SHG_use_90days nonumu_SACCO_loan_only umu_SACCO_loan_only SHG_loan_only

*Create global of coverage indicators
global coverage_indicators inform_finserv_loan nonumu_finserv_loan umu_finserv_loan SHG_finserv_loan inform_finserv_sav /*
*/ nonumu_finserv_sav umu_finserv_sav SHG_finserv_sav nonumu_SACCO_finserv_any umu_SACCO_finserv_any umu_SACCO_acct nonumu_SACCO_acct /*
*/ coop_VSLA_acct inform_fin_serv SACCO_fin_serv coop_fin_serv SHG_fin_serv coop_use_self_report nonumu_SACCO_use_self_report /*
*/ umu_SACCO_use_self_report SHG_use_self_report SACCO_use_any coop_use_any SHG_use_any 

*Create global of disaggregators
global disaggregation female rural MM_use phone_own official_id bank_own

*Create global of users vs. non-user indicators
	*Cooperative (unspecified), Informal Financial Group, SACCO
	gen inform_use_any = inform_fin_serv
	gen inform_no_use = .
	replace inform_no_use = 1 if inform_use_any == 0
	replace inform_no_use = 0 if inform_use_any == 1
	gen coop_no_use = .
	replace coop_no_use = 1 if coop_use_any == 0
	replace coop_no_use = 0 if coop_use_any == 1
	gen SACCO_no_use = .
	replace SACCO_no_use = 1 if SACCO_use_any == 0 
	replace SACCO_no_use = 0 if SACCO_use_any == 1
	
global user_nonusers SHG_use_any SHG_no_use SHG_fin_serv SACCO_use_any SACCO_no_use SACCO_fin_serv coop_use_any coop_no_use coop_fin_serv inform_use_any inform_fin_serv inform_no_use

*Create global of country demographics
global country_demographics female male rural urban MM_use no_MM_use phone_own no_phone_own official_id no_official_id bank_own no_bank_own

*Create global of user/non-user disaggregators
global disagg_user_nonuser female male rural urban MM_use no_MM_use phone_own no_phone_own official_id no_official_id bank_own no_bank_own

*Coverage indicators
putexcel set "$final_data\RW_FII_estimates.xls", modify sheet("Coverage", replace)

svyset [pweight=weight] //we can't specify the correct strata and cluster units here which may affect the SE and CI
local row=2 //Start export into row 2

foreach v of global coverage_indicators {
	quietly svy: mean `v'
	matrix prev_estimates=r(table)'
	matselrc prev_estimates mean_se, c(1 2 5 6) //need to install this package if Stata doesn't recognize this command
	putexcel 	A`row'="FII" C`row'="Coverage" I`row'="1.4 All individuals" ///
				L`row'="`v'" M`row'=matrix(mean_se) Q`row'=(e(N))
	local ++row
}	
		
foreach v of global coverage_indicators {		
	foreach x of global disaggregation {		
		forvalues i = 0/1 {
			quietly svy, subpop(if `x'==`i'): mean `v'
			matrix prev_estimates=r(table)'
			matselrc prev_estimates mean_se, c(1 2 5 6)
			putexcel 	A`row'="FII" C`row'="Coverage" I`row'="`x'=`i'" ///
						L`row'="`v'" M`row'=matrix(mean_se) Q`row'=(e(N_sub))
			local ++row
		}
	}	
}

*Characteristics indicators
putexcel set "$final_data\RW_FII_estimates.xls", modify sheet("Characteristics", replace)

svyset [pweight=weight] //we can't specify the correct strata and cluster units here which may affect the SE and CI
local row=2 //Start export into row 2

foreach v of global char_indicators {
	quietly svy: mean `v'
	matrix prev_estimates=r(table)'
	matselrc prev_estimates mean_se, c(1 2 5 6) //need to install this package if Stata doesn't recognize this command
	putexcel 	A`row'="FII" C`row'="Characteristics" I`row'="1.4 All individuals" ///
				L`row'="`v'" M`row'=matrix(mean_se) Q`row'=(e(N))
	local ++row
}	
		
foreach v of global char_indicators {		
	foreach x of global disaggregation {		
		forvalues i = 0/1 {
			quietly svy, subpop(if `x'==`i'): mean `v'
			matrix prev_estimates=r(table)'
			matselrc prev_estimates mean_se, c(1 2 5 6)
			putexcel 	A`row'="FII" C`row'="Characteristics" I`row'="`x'=`i'" ///
						L`row'="`v'" M`row'=matrix(mean_se) Q`row'=(e(N_sub))
			local ++row
		}
	}	
}


 *Users vs. Non-Users Disaggregation
putexcel set "$final_data\RW_FII_estimates.xls", modify sheet("Users vs. Non-Users", replace)

svyset [pweight=weight] //we can't specify the correct strata and cluster units here which may affect the SE and CI
local row=2 //Start export into row 2

foreach v of global disagg_user_nonuser {		
	foreach x of global user_nonusers {		
			quietly svy, subpop(if `x'==1): mean `v'
			matrix prev_estimates=r(table)'
			matselrc prev_estimates mean_se, c(1 2 5 6)
			putexcel 	A`row'="Kenya" C`row'="FII" E`row'="Proportion of individuals who exhibit each characteristic" ///
						F`row'="`x'" H`row'="`v'=1" I`row'=matrix(mean_se) M`row'=(e(N_sub))
			local ++row
	}	
}


	

*Country Demographics indicators
putexcel set "$final_data\RW_FII_estimates.xls", modify sheet("Country Demographics", replace)

svyset [pweight=weight] //we can't specify the correct strata and cluster units here which may affect the SE and CI
local row=2 //Start export into row 2
	
foreach x of global country_demographics {		
			quietly svy : mean `x'
			matrix prev_estimates=r(table)'
			matselrc prev_estimates mean_se, c(1 2 5 6)
			putexcel 	A`row'="FII" C`row'="Demographics" I`row'="`x'=`1'" ///
						L`row'="`v'" M`row'=matrix(mean_se) Q`row'=(e(N))
			local ++row
		
}





