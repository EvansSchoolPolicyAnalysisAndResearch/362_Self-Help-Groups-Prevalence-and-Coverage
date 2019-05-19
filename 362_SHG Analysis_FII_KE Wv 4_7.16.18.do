
/*---------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	: This do.file was developed by the Evans School Policy Analysis & Research Group (EPAR) 
				  for the construction of indicators related to Coverage and Characteristics of Self-Help Groups using the
				  Kenya Financial Inclusion Insights (FII) survey Wave 4 (2016) 													
*Author(s)		: Pierre Biscaye, Kirby Callaway, Elan Ebeling, Annie Rose Favreau, Mel Howlett, 
				  Daniel Lunchik-Seymour, Emily Morton, Kels Phelps,
				  C. Leigh Anderson & Travis Reynolds

				*Acknowledgments: We acknowledge the helpful contributions of members of the Bill & Melinda Gates Foundation Gender Equality team in 
				 discussing indicator construction decisions. All coding errors remain ours alone.
				 
*Date			: 13 July 2018
----------------------------------------------------------------------------------------------------------------------------------------------------*/

*Data source
*-----------
*The Kenya Financial Inclusion Insights survey was collected by InterMedia in August 2016.
*All the raw data, questionnaires, and basic information documents are available upon request from the 
*InterMedia website: http://finclusion.org/

*Summary of executing the Master do.file
*-----------
*This master do file constructs selected indicators using the Kenya FII data set.
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
*Kenya FII Wave 4

global KE_FIIW4_data 							"FII/Raw Data"
global created_data 							"FII/Created Data"
global final_data 								"FII/Outputs"

************
*CLEAN DATA
************
use "$KE_FIIW4_data\Kenya Wave 4 Stata.dta", clear
keep Serial DG2 DG5* AA7 poverty ppi* UR /* relevant demographic data


*/ DL28 /* emergency
*/ MT2 MT3* MT7 MT10 MT15 /* Mobile phone ownership
*/ FF1 FF4 FF14_22 /* Bank use
*/ MM2* MM4* MM15_22 /* Mobile money use
**Keep in mind the MNOs are different country to country
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
ren UR urban_rural
*Segmentation
ren DG2 gender
ren MT2 phone_ownership
ren MT7 phone_access
ren FF1 bank_ownership
*Mobile Money
ren MM2_1 aware_safaricom
ren MM2_2 aware_airtel
ren MM2_3 aware_yucash
ren MM2_4 aware_orange
ren MM2_5 aware_tangaza
ren MM2_6 aware_mobikash
ren MM2_7 aware_equitel
ren MM2_96 aware_other 
ren MM4_1 use_safaricom
ren MM4_2 use_airtel
ren MM4_3 use_yucash
ren MM4_4 use_orange
ren MM4_5 use_tangaza
ren MM4_6 use_mobikash
ren MM4_7 use_equitel
ren MM4_96 use_other 

*Official ID
ren DG5_1 id_gov
ren DG5_2 id_EApassport
ren DG5_3 id_intpassport
ren DG5_4 id_driver 
ren DG5_6 id_voter
ren DG5_8 id_employee
ren DG5_9 id_military
ren DG5_10 id_birthcert
*Self-reported use
ren IFI1_1 use_MFI
ren IFI1_2 use_coop
ren IFI1_3 use_SACCO	//Savings and Credit Cooperatives
ren IFI1_4 use_postoffice
ren IFI1_5 use_merry
ren IFI1_6 use_moneyguard
ren IFI1_7 use_savcollector
ren IFI1_8 use_digicard
ren IFI1_9 use_otherfinserv
*Financial Services
ren DL28 recovery_method
ren FL4 advice_source
ren FB16_4 loan_SACCO
ren FB22_3 sav_SACCO
ren IFI3_3 fin_acct_SACCO
ren FB16_7 loan_ASCA
ren FB22_5 sav_ASCA
ren FB16_8 loan_merry
ren FB22_6 sav_merry
ren IFI3_2 acct_coop
ren IFI18 member_SHG
ren FB16A_4 loan_current_SACCO
ren FB16A_7 loan_current_ASCA	//Accumulating Savings and Credit Associations
ren FB16A_8 loan_current_merry
*Characteristics
ren IFI7_1 coop_app
ren IFI7_2 coop_debit
ren IFI7_3 coop_credit
ren IFI7_4 coop_transfer
ren IFI8_1 SACCO_app
ren IFI8_2 SACCO_debit
ren IFI8_3 SACCO_credit
ren IFI8_4 SACCO_transfer
ren IFI22_# neg_exp_#
ren FB17_4 int_loan_SACCO
ren FB17_7 int_loan_ASCA
ren FB17_8 int_loan_merry
ren FB23_3 int_sav_SACCO
ren FB23_5 int_sav_ASCA
ren FB23_6 int_sav_merry
ren IFI2_2 recent_coop
ren IFI2_3 recent_SACCO
ren IFI2_5 recent_merry
ren IFI5_2 loan_only_coop
ren IFI5_3 loan_only_SACCO


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
//n=3,000

*Poverty 
gen two_low_PPI = . 
lab var two_low_PPI "Two lowest PPI Quintiles" //Two lowest quintiles = 1, Else = 0
replace two_low_PPI = 0 if ppi_score > 40
replace two_low_PPI = 1 if ppi_score <= 40
//n=3,000

gen mid_PPI = . 
lab var mid_PPI "Middle PPI Quintile" //Middle quintile = 1, Else = 0
replace mid_PPI = 0 if ppi_score <= 40 | ppi_score > 60
replace mid_PPI = 1 if ppi_score > 40 & ppi_score <= 60 
//n=3,000

gen two_high_PPI = . 
lab var two_high_PPI "Two highest PPI Quintiles" //Two highest quintiles = 1, Else = 0
replace two_high_PPI = 0 if ppi_score <= 60
replace two_high_PPI = 1 if ppi_score > 60
//n=3,000

*Gender
gen female = .
lab var female "1 = Female"
replace female = 1 if gender==2
replace female = 0 if gender==1
//n=3,000

*Mobile phone and bank ownership and access
gen phone_own = .
lab var phone_own "Individual owns or has access to a mobile phone"
replace phone_own = 0 if phone_ownership == 2 | phone_access == 2
replace phone_own = 1 if phone_ownership == 1 | phone_access == 1
//n=3,000

**Bank Account
gen bank_own = .
lab var bank_own "Individual has bank account registered in their name"
replace bank_own = 0 if bank_ownership == 2
replace bank_own = 1 if bank_ownership == 1 
//n=3,000

**EVER USED MOBILE MONEY
gen MM_use = 0 
lab var MM_use "Individual has used Mobile Money for any financial activity"
replace MM_use = 1 if use_safaricom==1 | use_airtel==1 | use_yucash==1 | use_orange==1 | use_tangaza==1 | use_mobikash==1 | use_equitel==1 | use_other ==1 
//n = 3,000 

**OFFICIAL ID
gen official_id = .
lab var official_id "Individual has official identification"
replace official_id = 1 if id_gov==1 | id_EApassport==1 | id_intpassport==1 | id_driver==1 | id_voter==1 | id_employee==1 | id_military==1 | id_birthcert==1 
replace official_id = 0 if id_gov==2 & id_EApassport==2 & id_intpassport==2 & id_driver==2 & id_voter==2 & id_employee==2 & id_military==2 & id_birthcert==2 
//n=3,000


************
**COVERAGE
************

************
*PROPORTION OF INDIVIDUALS who depend most on SHGs for financial advice
************
*Individuals who primarily rely on SACCOs for financial advice
gen SACCO_advice = .
lab var SACCO_advice "Proportion of individuals who have received financial advice from a SACCO(Among all question respondents)"
replace SACCO_advice = 0 if advice_source != . 
replace SACCO_advice = 1 if advice_source == 5 //5 = SACCO

*Individuals who primarily rely on merry-go-rounds for financial advice
gen merry_advice = .
lab var merry_advice "Proportion of individuals who have received financial advice from a merry-go-round (Among all question respondents)"
replace merry_advice = 0 if advice_source != . 
replace merry_advice = 1 if advice_source == 6 //6 = merry-go-round

*Individuals who primarily rely on any SHG for financial advice
gen SHG_advice = .
lab var SHG_advice "Proportion of individuals who have primarily received financial advice from a SHG (Among all question respondents)"
replace SHG_advice = 0 if SACCO_advice == 0 | merry_advice == 0
replace SHG_advice = 1 if SACCO_advice == 1 | merry_advice == 1
//n=3,000

************ 
*PROPORTION OF SHG USERS who receive financial services from SHG
************
*Individuals who have borrowed money from SACCO
gen SACCO_loan = .
lab var SACCO_loan "SACCO - loan"
replace SACCO_loan = 0 if loan_SACCO==2 //FB16_4 = SACCO
replace SACCO_loan = 1 if loan_SACCO==1 

*Individuals who have saved money with SACCOs
gen SACCO_savings = .
lab var SACCO_savings "SACCO - savings"
replace SACCO_savings = 0 if sav_SACCO==2 //FB22_3 = SACCO
replace SACCO_savings = 1 if sav_SACCO==1

*Individuals with financial account through SACCO
gen SACCO_fin_acct = .
lab var SACCO_fin_acct "SACCO - financial account"
replace SACCO_fin_acct = 0 if use_SACCO != . | fin_acct_SACCO==2 //IFI3_3 = SACCO account
replace SACCO_fin_acct = 1 if fin_acct_SACCO==1 

*Individuals who have borrowed money from ASCA
gen ASCA_loan = .
lab var ASCA_loan "ASCA - loan"
replace ASCA_loan = 0 if loan_ASCA==2 //FB16_7 = ASCA
replace ASCA_loan = 1 if loan_ASCA==1 

*Individuals who have saved money with ASCA/VSLA
gen ASCA_savings = .
lab var ASCA_savings "ASCA/VSLA - savings"
replace ASCA_savings = 0 if sav_ASCA==2 //FB22_5 = ASCA/VSLA
replace ASCA_savings = 1 if sav_ASCA==1

*Individuals who have borrowed money from merry-go-round
gen merry_loan = .
lab var merry_loan "Merry-go-round - loan"
replace merry_loan = 0 if loan_merry==2 //FB16_8 = merry-go-round
replace merry_loan = 1 if loan_merry==1 

*Individuals who have saved money with merry-go-round
gen merry_savings = .
lab var merry_savings "Merry-go-round - savings"
replace merry_savings = 0 if sav_merry==2 //FB22_6 = merry-go-round
replace merry_savings = 1 if sav_merry==1

*Individual who used SACCOs for financial services
gen SACCO_fin_serv = . 
lab var SACCO_fin_serv "Proportion of individuals who accessed financial services from a SACCO (Among all question respondents)"
replace SACCO_fin_serv = 0 if SACCO_loan == 0 | SACCO_savings == 0 | SACCO_fin_acct == 0 
replace SACCO_fin_serv = 1 if SACCO_loan == 1 | SACCO_savings == 1 | SACCO_fin_acct == 1 
//n=3,000

*Individuals who used ASCAs for financial services
gen ASCA_fin_serv = .
lab var ASCA_fin_serv "Proportion of individuals who accessed financial services from an ASCA (Among all question respondents)"
replace ASCA_fin_serv = 0 if ASCA_loan == 0 | ASCA_savings == 0
replace ASCA_fin_serv = 1 if ASCA_loan == 1 | ASCA_savings == 1
//n=3,000

*Individuals who used merry go round for financial services
gen merry_fin_serv = .
lab var merry_fin_serv "Proportion of individuals who accessed financial services from a merry go round (Among all question respondents)"
replace merry_fin_serv = 0 if merry_loan == 0 | merry_savings == 0
replace merry_fin_serv = 1 if merry_loan == 1 | merry_savings == 1
//n = 3,000

*Individuals with financial account with cooperative
gen coop_fin_serv = . 
lab var coop_fin_serv "Proportion of individuals who accessed financial services from a cooperative (Among all question respondents)"
replace coop_fin_serv = 0 if use_coop!=. | acct_coop==2 //IFI3_2 = cooperative acct 
replace coop_fin_serv = 1 if acct_coop==1 
// n = 3000 

*Individuals who used any SHG for financial services
gen SHG_fin_serv = .
lab var SHG_fin_serv "Proportion of individuals who accessed financial services from a SHG (Among all question respondents)"
replace SHG_fin_serv = 0 if SACCO_fin_serv == 0 | ASCA_fin_serv == 0 | merry_fin_serv == 0 | coop_fin_serv == 0
replace SHG_fin_serv = 1 if SACCO_fin_serv == 1 | ASCA_fin_serv == 1 | merry_fin_serv == 1 | coop_fin_serv == 1
//n = 3,000


************
*PROPORTION OF INDIVIDUALS who have used a SHG in any way 
************
*Individuals who report ever using a Cooperative 
gen coop_use_self_report= . 
lab var coop_use_self_report "Individual reports using a cooperative"
replace coop_use_self_report = 0 if use_MFI != . | use_coop != . | use_SACCO != . | use_postoffice != . | use_merry != . | use_moneyguard != . | use_savcollector != . | use_digicard != . | use_otherfinserv != .  
replace coop_use_self_report = 1 if use_coop == 1 //IFI1 = have you ever used any of the following. _2 = cooperative

*Individuals who report ever using a SACCO
gen SACCO_use_self_report = . 
lab var SACCO_use_self_report "Individual reports using a SACCO"
replace SACCO_use_self_report = 0 if use_MFI != . | use_coop != . | use_SACCO != . | use_postoffice != . | use_merry != . | use_moneyguard != . | use_savcollector != . | use_digicard != . | use_otherfinserv != .   
replace SACCO_use_self_report = 1 if use_SACCO == 1 //IFI1 = have you ever used any of the following. _3 = SACCO

*Individuals who report ever using a merry go round
gen merry_use_self_report = . 
lab var merry_use_self_report "Individual reports using a merry go round"
replace merry_use_self_report = 0 if use_MFI != . | use_coop != . | use_SACCO != . | use_postoffice != . | use_merry != . | use_moneyguard != . | use_savcollector != . | use_digicard != . | use_otherfinserv != .  
replace merry_use_self_report = 1 if use_merry == 1 //IFI1 = have you ever used any of the following. _5 = merry go round

*Individuals who report ever using any SHG
gen SHG_use_self_report = .
lab var SHG_use_self_report "Individual reports using any SHG"
replace SHG_use_self_report = 0 if coop_use_self_report == 0 | SACCO_use_self_report == 0 | merry_use_self_report == 0
replace SHG_use_self_report = 1 if coop_use_self_report == 1 | SACCO_use_self_report == 1 | merry_use_self_report == 1
//n = 3,000

*Individuals who belong to "informal societies or group savings schemes"
gen SHG_membership = .
lab var SHG_membership "Individual belongs to informal societies or group savings schemes"
replace SHG_membership = 0 if member_SHG==0 //member_SHG - How many informal societies or group savings schemes do you personally belong to? 99=missing
replace SHG_membership = 1 if member_SHG>0 & member_SHG<99
//n = 2,932 - 68 repondents "Don't Know" and set to missing

*Individuals who have interacted with a SACCO in any way 
gen SACCO_use_any = .
lab var SACCO_use_any "Proportion of individuals who have interacted with a SACCO (Among all question respondents)"
replace SACCO_use_any = 0 if SACCO_use_self_report == 0 | SACCO_fin_serv == 0 | SACCO_advice == 0
replace SACCO_use_any = 1 if SACCO_use_self_report == 1 | SACCO_fin_serv == 1 |SACCO_advice == 1 
//n = 3,000

*Individuals who have interacted with a cooperative in any way
gen coop_use_any = .
lab var coop_use_any "Proportion of individuals who have interacted with a cooperative (Among all question respondents)"
replace coop_use_any = 0 if coop_use_self_report == 0 | coop_fin_serv == 0 
replace coop_use_any = 1 if coop_use_self_report == 1 | coop_fin_serv == 1 

*Individuals who have interacted with a merry go round in any way
gen merry_use_any = .
lab var merry_use_any "Proportion of individuals who have interacted with a merry go round (Among all question respondents)"
replace merry_use_any = 0 if merry_use_self_report == 0 | merry_advice == 0 | merry_fin_serv == 0
replace merry_use_any = 1 if merry_use_self_report == 1 | merry_advice == 1 | merry_fin_serv == 1

*Individuals who have interacted with a SHG in any way
gen SHG_use_any = .
lab var SHG_use_any "Proportion of individuals who have interacted with a SHG (Among all question respondents)"
replace SHG_use_any = 0 if SHG_membership == 0 | SACCO_use_any == 0 | coop_use_any == 0 | merry_use_any == 0
replace SHG_use_any = 1 if SHG_membership == 1 | SACCO_use_any == 1 | coop_use_any == 1 | merry_use_any == 1
//n=3,000

************
**CHARACTERISTICS
************

************
*PROPORTION OF INDIVIDUALS who have current loans with SHGs 
************
*Individuals who have current loans with SACCO 
gen SACCO_loan_current = .
lab var SACCO_loan_current "Proportion of individuals who have a current loan with a SACCO (Among all question respondents)"
replace SACCO_loan_current = 0 if SACCO_loan != . //accounting for skip logic in question FB16_4 - have you borrowed money/have loans from the following organizations or individuals? 
replace SACCO_loan_current = 1 if loan_current_SACCO == 1
//n=3000

*Individuals who have current loans with ASCA 
gen ASCA_loan_current = .
lab var ASCA_loan_current "Proportion of individuals who have a current loan with an ASCA (Among all question respondents)"
replace ASCA_loan_current = 0 if ASCA_loan != . //accounting for skip logic in question FB16_7 - have you borrowed money/have loans from the following organizations or individuals? 
replace ASCA_loan_current = 1 if loan_current_ASCA == 1 
//n = 3000

*Individuals who have current loans with merry-go-round 
gen merry_loan_current = .
lab var merry_loan_current "Proportion of individuals who have a current loan with a merry-go-round (Among all question respondents)"
replace merry_loan_current = 0 if merry_loan != . //loan_current_merry = merry-go-round
replace merry_loan_current = 1 if loan_current_merry == 1 
//n=3000

*Individuals who have current loans with any SHG
gen SHG_loan_current = .
lab var SHG_loan_current "Proportion of individuals who have a current loan with a SHG (Among all question respondents)"
replace SHG_loan_current = 0 if SACCO_loan_current == 0 | ASCA_loan_current == 0 | merry_loan_current == 0
replace SHG_loan_current = 1 if SACCO_loan_current == 1 | ASCA_loan_current == 1 | merry_loan_current == 1
//n = 3000

************
*PROPORTION OF INDIVIDUALS who used a savings/lending group to recover from a financial challenge
************
*Individuals who used a savings/lending to recover from financial challenge
gen SHG_use_emergency = 0 
lab var SHG_use_emergency "Proportion of individuals who used a savings/lending group to recover from a financial challenge (Among all question respondents)"
replace SHG_use_emergency = 0 if recovery_method!=3 & recovery_method != 99
replace SHG_use_emergency = 1 if recovery_method==3 //3 = savings/lending group.

************
*PROPORTION OF INDIVIDUALS who belong to SHGs which offer mobile services
************
*Mobile Services available through cooperatives.
gen coop_mobile_serv = . 
lab var coop_mobile_serv "Proportion of individuals who belong to cooperatives which offer mobile services (Among all question respondents)"
replace coop_mobile_serv = 0 if use_coop != . //IFI1_2 = have you ever used a cooperative
replace coop_mobile_serv = 1 if coop_app == 1 | coop_debit == 1 | coop_credit == 1 | coop_transfer == 1 
//n = 3,000

*Mobile Services available through SACCOs.
gen SACCO_mobile_serv = . 
lab var SACCO_mobile_serv "Proportion of individuals who belong to SACCOs which offer mobile services (Among all question respondents)"
replace SACCO_mobile_serv = 0 if use_SACCO != .
replace SACCO_mobile_serv = 1 if SACCO_app == 1 | SACCO_debit == 1 | SACCO_credit == 1 | SACCO_transfer == 1 //IFI8 = SACCO, _1 = access acct with mobile app or internet, _2 = debit/atm card, _3 = credit card, _4 = transfer without using cash
//n=3,000

*Mobile Services available through SHG.
gen SHG_mobile_serv = . 
lab var SHG_mobile_serv "Proportion of individuals who belong to SHGs which offer mobile services (Among all question respondents)"
replace SHG_mobile_serv = 0 if coop_mobile_serv == 0 | SACCO_mobile_serv == 0
replace SHG_mobile_serv = 1 if coop_mobile_serv == 1 | SACCO_mobile_serv == 1
//n = 3,000

************
*PROPORTION OF INDIVIDUALS reporting negative experiences with SHGs
************
*Individuals reporting negative experiences with SHGs 
gen SHG_neg_any = .
lab var SHG_neg_any "Proportion of Individuals who reported a negative SHG experience (Among individuals with SHG experience)" // Lost money through fraud or bad investment, lost membership, poor leadership, cash not available immediately
foreach x of numlist 1/6 {
replace SHG_neg_any = 0 if neg_exp_`x' == 2 
}
foreach x of numlist 1/6 {
replace SHG_neg_any = 1 if neg_exp_`x' == 1 
}

gen SHG_neg_theft_out = .
lab var SHG_neg_theft_out "Proportion of individuals who report theft from their SHG by someone outside the group (Among individuals with SHG experience)"
replace SHG_neg_theft_out = 0 if neg_exp_1 == 2
replace SHG_neg_theft_out = 1 if neg_exp_1 == 1

gen SHG_neg_theft_in = .
lab var SHG_neg_theft_in "Proportion of individuals who report theft from their SHG by someone inside the group (Among individuals with SHG experience)"
replace SHG_neg_theft_in = 0 if neg_exp_2 == 2
replace SHG_neg_theft_in = 1 if neg_exp_2 == 1

gen SHG_neg_bad_invest = .
lab var SHG_neg_bad_invest "Proportion of individuals who report loss of funds through bad investment (Among individuals with SHG experience)"
replace SHG_neg_bad_invest = 0 if neg_exp_3 == 2
replace SHG_neg_bad_invest = 1 if neg_exp_3 == 1

gen SHG_neg_death_cancel = .
lab var SHG_neg_death_cancel "Proportion of individuals who report that they lost their SHG membership through death or cancellation (Among individuals with SHG experience)"
replace SHG_neg_death_cancel = 0 if neg_exp_4 == 2
replace SHG_neg_death_cancel = 1 if neg_exp_4 == 1

gen SHG_neg_poor_leader = .
lab var SHG_neg_poor_leader "Proportion of individuals who report poor leadership in their SHG (Among individuals with SHG experience)"
replace SHG_neg_poor_leader = 0 if neg_exp_5 == 2
replace SHG_neg_poor_leader = 1 if neg_exp_5 == 1

gen SHG_neg_cash_unavailable = .
lab var SHG_neg_cash_unavailable "Proportion of individuals who report cash not being immediately available in their SHG (Among individuals with SHG experience)"
replace SHG_neg_cash_unavailable = 0 if neg_exp_6 == 2
replace SHG_neg_cash_unavailable = 1 if neg_exp_6 == 1

************
*PROPORTION OF INDIVIDUALS who know the interest rate of their SHG loan
************
*Individuals who know the interest rate of their loan with SACCO
gen SACCO_int_rt_loan = . 
lab var SACCO_int_rt_loan "Individual knows interest rate of their SACCO loan (Among those who have a SACCO loan)"
replace SACCO_int_rt_loan = 0 if int_loan_SACCO == 2 //FB17_4 = SACCO
replace SACCO_int_rt_loan = 1 if int_loan_SACCO == 1 
//n = 149

*Individuals who know the interest rate of their loan with ASCA
gen ASCA_int_rt_loan = . 
lab var ASCA_int_rt_loan "Individual knows interest rate of their ASCA loan (Among those who have an ASCA loan)"
replace ASCA_int_rt_loan = 0 if int_loan_ASCA == 2 //FB17_7 = Loan from an ASCA 
replace ASCA_int_rt_loan = 1 if int_loan_ASCA == 1 
//n = 83

*Individuals who know the interest rate of their loan with merry-go-round
gen merry_int_rt_loan = . 
lab var merry_int_rt_loan "Individual knows interest rate of their merry-go-round loan (Among those who have a merry-go-round loan)"
replace merry_int_rt_loan = 0 if int_loan_merry == 2 //FB17_8 = merry-go-round
replace merry_int_rt_loan = 1 if int_loan_merry == 1
//n = 507


************
*PROPORTION OF INDIVIDUALS who know the interest rate of their SHG savings account
************
*Individuals who know the interest rate of their savings acct with SACCO
gen SACCO_int_rt_sav = . 
lab var SACCO_int_rt_sav "Individual knows interest rate of their SACCO savings account (Among those who save with a SACCO account)"
replace SACCO_int_rt_sav = 0 if int_sav_SACCO == 2 //FB23_3 = SACCO
replace SACCO_int_rt_sav = 1 if int_sav_SACCO == 1 
// n=193 (193 answered "yes" to FB22_3 - Do you save with a SACCO account"

*Individuals who know the interest rate of their savings acct with ASCA/VSLA
gen ASCA_int_rt_sav = . 
lab var ASCA_int_rt_sav "Individual knows interest rate of their ASCA/VSLA savings account (Among those who save with an ASCA account)"
replace ASCA_int_rt_sav = 0 if int_sav_ASCA == 2 //FB23_5 = ASCAVSLA
replace ASCA_int_rt_sav = 1 if int_sav_ASCA == 1 
//n=82

*Individuals who know the interest rate of their savings acct with merry-go-round
gen merry_int_rt_sav = . 
lab var merry_int_rt_sav "Individual knows interest rate of their merry-go-round savings account"
replace merry_int_rt_sav = 0 if int_sav_merry == 2  //FB23_6 = merry-go-round
replace merry_int_rt_sav = 1 if int_sav_merry == 1
//n=523

************
*PROPORTION OF INDIVIDUALS who know the interest rate of their SHG account
************
*Individuals who know the interest rate of their SACCO account
gen SACCO_int_rt_any = . 
lab var SACCO_int_rt_any "Proportion of individuals who know the interest rate of their SACCO account (Among all account holders)"
replace SACCO_int_rt_any = 0 if SACCO_int_rt_loan == 0 | SACCO_int_rt_sav == 0
replace SACCO_int_rt_any = 1 if SACCO_int_rt_loan == 1 | SACCO_int_rt_sav == 1
//n=233

*Individuals who know the interest rate of their ASCA/VSLA account
gen ASCA_int_rt_any = . 
lab var ASCA_int_rt_any "Proportion of individuals who know the interest rate of their ASCA account (Among all account holders)"
replace ASCA_int_rt_any = 0 if ASCA_int_rt_loan == 0 | ASCA_int_rt_sav == 0
replace ASCA_int_rt_any = 1 if ASCA_int_rt_loan == 1 | ASCA_int_rt_sav == 1
//n=83

*Individuals who know the interest rate merry go round account
gen merry_int_rt_any = . 
lab var merry_int_rt_any "Proportion of individuals who know the interest rate of their merry go round account (Among all account holders)"
replace merry_int_rt_any = 0 if merry_int_rt_loan == 0 | merry_int_rt_sav == 0
replace merry_int_rt_any = 1 if merry_int_rt_loan == 1 | merry_int_rt_sav == 1
//n=741

*Individuals who know they interest rate of their SHG accout
gen SHG_int_rt_any = .
lab var SHG_int_rt_any "Proportion of individuals who know the interest rate of their SHG account (Among all account holders)"
replace SHG_int_rt_any = 0 if SACCO_int_rt_any == 0 | ASCA_int_rt_any == 0 | merry_int_rt_any == 0 
replace SHG_int_rt_any = 1 if SACCO_int_rt_any == 1 | ASCA_int_rt_any == 1 | merry_int_rt_any == 1 
//n=917

************
*PROPORTION OF INDIVIDUALS who used SHG recently
************
*Individuals who used cooperative in past 30 days
gen coop_use_30days = .
lab var coop_use_30days "Proportion of individuals who have used a cooperative in the past 30 days (Among all question respondents)"
replace coop_use_30days = 0 if recent_coop>3 
replace coop_use_30days = 1 if recent_coop<=3 
//n=3,000

*Individuals who used SACCO in past 30 days
gen SACCO_use_30days = .
lab var SACCO_use_30days "Proportion of individuals who have used a SACCO in the past 30 days (Among all question respondents)"
replace SACCO_use_30days = 0 if recent_SACCO>3
replace SACCO_use_30days = 1 if recent_SACCO<=3
//n= 3,000

*Individuals who used merry go round in past 30 days
gen merry_use_30days = .
lab var merry_use_30days "Proportion of individuals who have used a merry go round in the past 30 days (Among all question respondents)"
replace merry_use_30days = 0 if recent_merry>3 
replace merry_use_30days = 1 if recent_merry<=3
//n=3,000

*Individuals who used any SHG in past 30 days
gen SHG_use_30days = .
lab var SHG_use_30days "Proportion of individuals who have used any SHG in the past 30 days (Among all question respondents)"
replace SHG_use_30days = 0 if coop_use_30days == 0 | SACCO_use_30days == 0 | merry_use_30days == 0
replace SHG_use_30days = 1 if coop_use_30days == 1 | SACCO_use_30days == 1 | merry_use_30days == 1
//n=3,000

*Individuals who used cooperative in past 90 days
gen coop_use_90days = .
lab var coop_use_90days "Proportion of individuals who have used a cooperative in the past 90 days (Among all question respondents)"
replace coop_use_90days = 0 if recent_coop>4
replace coop_use_90days = 1 if recent_coop<=4 

*Individuals who used SACCO in past 90 days
gen SACCO_use_90days = .
lab var SACCO_use_90days "Proportion of individuals who have used a SACCO in the past 90 days (Among all question respondents)"
replace SACCO_use_90days = 0 if recent_SACCO>4 
replace SACCO_use_90days = 1 if recent_SACCO<=4 

*Individuals who used merry go round in past 90 days
gen merry_use_90days = .
lab var merry_use_90days "Proportion of individuals who have used a merry go round in the past 90 days (Among all question respondents)"
replace merry_use_90days = 0 if recent_merry>4 
replace merry_use_90days = 1 if recent_merry<=4

*Individuals who used any SHG in past 90 days
gen SHG_use_90days = .
lab var SHG_use_90days "Proportion of individuals who have used any SHG in the past 90 days (Among all question respondents)"
replace SHG_use_90days = 0 if coop_use_90days == 0 | SACCO_use_90days == 0 | merry_use_90days == 0
replace SHG_use_90days = 1 if coop_use_90days == 1 | SACCO_use_90days == 1 | merry_use_90days == 1
//n=3,000

************
*PROPORTION OF INDIVIDUALS whose SHG offers only loans
************
*Individuals whose cooperative offers "loans only"
gen coop_loan_only = . 
lab var coop_loan_only "Proportion of individuals who belong to a cooperative which offer only loan services (Among all question respondents)"
replace coop_loan_only = 0 if use_coop != . 
replace coop_loan_only = 1 if loan_only_coop == 2 //IFI5_2 response 2 = only loans
//n=3,000

*Individuals whose SACCO offers "loans only"
gen SACCO_loan_only = .
lab var SACCO_loan_only "Proportion of individuals who belong to a SACCO which offer only loan services (Among all question respondents)"
replace SACCO_loan_only = 0 if use_SACCO != . 
replace SACCO_loan_only = 1 if loan_only_SACCO == 2
//n=3,000

*Individuals whose SHG (any) offers "loans only"
gen SHG_loan_only = .
lab var SHG_loan_only "Proportion of individuals who belong to any SHG which offer only loan services (Among all question respondents)"
replace SHG_loan_only = 0 if coop_loan_only == 0 | SACCO_loan_only == 0 
replace SHG_loan_only = 1 if coop_loan_only == 1 | SACCO_loan_only == 1 
//n=3,000

************
*Counts of SHG why not 
************ 
rename IFI24 why_not_SHG

gen notSHG_bank = .
lab var notSHG_bank "Proportion of individuals who do not belong to a SHG because they have a bank account or other formal financial institution (Among individuals who do not belong to a SHG)"
replace notSHG_bank = 0 if why_not_SHG != .
replace notSHG_bank = 1 if why_not_SHG == 1
//n=1,901

gen notSHG_no_money = .
lab var notSHG_no_money "Proportion of individuals who do not belong to a SHG because they have no money left for savings (Among individuals who do not belong to a SHG)"
replace notSHG_no_money = 0 if why_not_SHG != .
replace notSHG_no_money = 1 if why_not_SHG == 2
//n=1901

gen notSHG_dont_know = .
lab var notSHG_dont_know "Proportion of individuals who do not belong to a SHG because they do not know about them (Among individuals who do not belong to a SHG)"
replace notSHG_dont_know = 0 if why_not_SHG != .
replace notSHG_dont_know = 1 if why_not_SHG == 3
//n=1901

gen notSHG_no_need = .
lab var notSHG_no_need "Proportion of individuals who do not belong to a SHG because they do not need their services (Among individuals who do not belong to a SHG)"
replace notSHG_no_need = 0 if why_not_SHG != .
replace notSHG_no_need = 1 if why_not_SHG == 4
//n=1901

gen notSHG_dont_trust = .
lab var notSHG_dont_trust "Proportion of individuals who do not belong to a SHG because they do not trust them (Among individuals who do not belong to a SHG)"
replace notSHG_dont_trust = 0 if why_not_SHG != .
replace notSHG_dont_trust = 1 if why_not_SHG == 5
//n=1901

gen notSHG_meeting_time = .
lab var notSHG_meeting_time "Proportion of individuals who do not belong to a SHG because they require too much time in meetings (Among individuals who do not belong to a SHG)"
replace notSHG_meeting_time = 0 if why_not_SHG != .
replace notSHG_meeting_time = 1 if why_not_SHG == 6
//n=1901

gen notSHG_bad_exp = .
lab var notSHG_bad_exp "Proportion of individuals who do not belong to a SHG because of a negative previous experience (Among individuals who do not belong to a SHG)"
replace notSHG_bad_exp = 0 if why_not_SHG != .
replace notSHG_bad_exp = 1 if why_not_SHG == 7
//n=1901

gen notSHG_dissolved = .
lab var notSHG_dissolved "Proportion of individuals who do not belong to a SHG because they dissolved their membership, and are debating joining another one (Among individuals who do not belong to a SHG)"
replace notSHG_dissolved = 0 if why_not_SHG != .
replace notSHG_dissolved = 1 if why_not_SHG == 8
//n=1901

gen notSHG_not_found = .
lab var notSHG_not_found "Proportion of individuals who do not belong to a SHG because they have not found group that suits their needs (Among individuals who do not belong to a SHG)"
replace notSHG_not_found = 0 if why_not_SHG != .
replace notSHG_not_found = 1 if why_not_SHG == 9
//n=1901

gen notSHG_other = .
lab var notSHG_other "Proportion of individuals who do not belong to a SHG because of another reason (Among individuals who do not belong to a SHG)"
replace notSHG_other = 0 if why_not_SHG != .
replace notSHG_other = 1 if why_not_SHG == 96
//n=1901

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
save "$created_data\KE_FII_final.dta", replace

************
*Disaggregate and Export
************ 

use "$created_data\KE_FII_final.dta", clear

*Create global of characteristic indicators
global char_indicators coop_use_30days SACCO_use_30days merry_use_30days SHG_use_30days coop_use_90days SACCO_use_90days merry_use_90days SHG_use_90days /*
*/ SHG_use_emergency  SACCO_loan_current ASCA_loan_current merry_loan_current SHG_loan_current coop_loan_only SACCO_loan_only SHG_loan_only /*
*/ SACCO_mobile_serv coop_mobile_serv SHG_mobile_serv SACCO_int_rt_any ASCA_int_rt_any merry_int_rt_any SHG_int_rt_any /*
*/ SHG_neg_any SHG_neg_theft_out SHG_neg_theft_in SHG_neg_bad_invest SHG_neg_death_cancel SHG_neg_poor_leader SHG_neg_cash_unavailable /*
*/ notSHG_bank notSHG_no_money notSHG_dont_know notSHG_no_need notSHG_dont_trust notSHG_meeting_time notSHG_bad_exp notSHG_dissolved notSHG_not_found notSHG_other 

*Create global of coverage indicators
global coverage_indicators SACCO_use_any coop_use_any merry_use_any SHG_membership SHG_use_any SACCO_advice merry_advice SHG_advice SACCO_fin_serv ASCA_fin_serv merry_fin_serv coop_fin_serv SHG_fin_serv

*Create global of disaggregators
global disaggregation female rural two_low_PPI mid_PPI two_high_PPI MM_use phone_own official_id bank_own

*Create global of users vs. non-user indicators
	*ASCAs, Coops, MGRs, SACCOs
	gen ASCA_use_any = ASCA_fin_serv
	gen ASCA_no_use = . 
	replace ASCA_no_use = 1 if ASCA_use_any == 0 
	replace ASCA_no_use = 0 if ASCA_use_any == 1
	gen merry_no_use = . 
	replace merry_no_use = 1 if merry_use_any == 0 
	replace merry_no_use = 0 if merry_use_any == 1
	gen SACCO_no_use = . 
	replace SACCO_no_use = 1 if SACCO_use_any == 0 
	replace SACCO_no_use = 0 if SACCO_use_any == 1
	gen coop_no_use = . 
	replace coop_no_use = 1 if coop_use_any == 0 
	replace coop_no_use = 0 if coop_use_any == 1

global user_nonusers SHG_use_any SHG_no_use SHG_fin_serv ASCA_use_any ASCA_no_use ASCA_fin_serv merry_use_any merry_no_use merry_fin_serv SACCO_use_any SACCO_no_use SACCO_fin_serv coop_use_any coop_no_use coop_fin_serv

*Create global of country demographics
global country_demographics female male rural urban two_low_PPI mid_PPI two_high_PPI MM_use no_MM_use phone_own no_phone_own official_id no_official_id bank_own no_bank_own

*Create global of user/non-user disaggregators
global disagg_user_nonuser female male rural urban two_low_PPI mid_PPI two_high_PPI MM_use no_MM_use phone_own no_phone_own official_id no_official_id bank_own no_bank_own

*Coverage indicators
putexcel set "$final_data\KE_FII_estimates.xls", modify sheet("Coverage", replace)

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
putexcel set "$final_data\KE_FII_estimates.xls", modify sheet("Characteristics", replace)

svyset [pweight=weight] //we can't specify the correct strata and cluster units here which may affect the SE and CI
local row=2 //Start export into row 2

foreach v of global char_indicators {
	quietly svy: mean `v'
	matrix prev_estimates=r(table)'
	matselrc prev_estimates mean_se, c(1 2 5 6) //need to install this package if Stata doesn't recognize this command
	putexcel 	A`row'="FII" C`row'="Characteristics" I`row'="1.1 All individuals" ///
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
putexcel set "$final_data\KE_FII_estimates.xls", modify sheet("Users vs. Non-Users", replace)

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
putexcel set "$final_data\KE_FII_estimates.xls", modify sheet("Country Demographics", replace)

svyset [pweight=weight] //we can't specify the correct strata and cluster units here which may affect the SE and CI
local row=2 //Start export into row 2
	
		
foreach x of global country_demographics {		
			quietly svy: mean `x'
			matrix prev_estimates=r(table)'
			matselrc prev_estimates mean_se, c(1 2 5 6)
			putexcel 	A`row'="FII" C`row'="Demographics" I`row'="`x'=`1'" ///
						L`row'="`v'" M`row'=matrix(mean_se) Q`row'=(e(N))
			local ++row
	
}




