
/*---------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	: This do.file was developed by the Evans School Policy Analysis & Research Group (EPAR) 
				  for the construction of indicators related to Coverage and Characteristics of Self-Help Groups using the
				  Tanzania FinScope survey Wave 4 (2017) 														
*Author(s)		: Pierre Biscaye, Kirby Callaway, Elan Ebeling, Annie Rose Favreau, Mel Howlett, 
				  Daniel Lunchik-Seymour, Emily Morton, Kels Phelps,
				  C. Leigh Anderson & Travis Reynolds

				*Acknowledgments: We acknowledge the helpful contributions of members of the Bill & Melinda Gates Foundation Gender Equality team in 
				discussing indicator construction decisions. All coding errors remain ours alone.
				
*Date			: 13 July 2018
----------------------------------------------------------------------------------------------------------------------------------------------------*/

*Data source
*-----------
*The Tanzania FinScope household survey was collected by the Financial Sector Deepening Trust (FSDT)
*over the period April - July 2017.
*All the raw data, questionnaires, and basic information documents are available for free for download from the 
*Financial Sector Deepening Trust website: http://www.fsdt.or.tz/finscope/

*Summary of executing the Master do.file
*-----------
*This master do file constructs selected indicators using the Tanzania FinScope data set.
*Using a data file from within the "Raw Data" folder within the "Finscope" folder, 
*the do-file constructs relevant indicators related to Self-Help Group coverage
*and Use and saves final dta files with all created variables and indicators
*in the "Created Data" folder within the "FinScope" folder.
*Additionally, the do-file creates Excel spreadsheet with estimates of coverage 
*and characteristic indicators disaggregated by gender, mobile phone access,
*bank account access, urban vs. rural, possession of official identification,
*poverty level, and mobile money use.
*These estimates are saved in the "Outputs" folder with in the "FinScope" folder.
*Throughought the do-file we refer to "Self-Help Groups" as "SHGs".

*The following refer to running this Master do.file with EPAR's cleaned data files. Information on EPAR's cleaning and construction decisions is available in the 
*"EPAR_UW_362_SHG_Indicator_CrossComparisons" spreadsheet. 

clear
set more off

//Set directories
*Tanzania FinScope Wave 4

global TZ_Finscope_data 								"FinScope/Raw Data"
global created_data 									"FinScope/Created Data"
global final_data 										"FinScope/Outputs"

************
*KEEP SHG RELEVANT VARIABLES 
************
use "$TZ_Finscope_data", clear
keep Region Region_C District Distric0  Ward Ward_Cod Village_ EA UEA_Code EA_Code UHH_SN /* 
*/ Cluster C8 C9 C10 C11 C23* C24* C25 C27* PPIScore PPI_Cate /*relevant demographic data
*/ E3_1 E3_3 /* ask advice
*/ F2 F4_1* /* save $ in past 12 months
*/ F3_2* /* confidence in saving  
*/ G2_1_1 G5_1* /* borrow $ in past 12 months
*/ G1_2* /* confidence in borrowing
*/ J1_1* /*service providers used
*/ H2* H5* /* payments - MM
*/ CB2_1* /* have a bank account
*/ SC* /*SACCO qs
*/ SG* /*saving group qs
*/ Final_we // weights

************************
*RENAME VARIABLES
************************
*DEMOGRAPHICS
**rural
rename Cluster rural_urban
**sex
rename C9 sex
**poverty
rename PPI_Cate PPI_quantiles 
**phone
rename C23_1 phone_access
rename C24_1 phone_own
**id types
rename C27_1 ntnl_id_card
rename C27_2 ntnl_id_num
rename C27_3 zanzibar_id
rename C27_4 voter_id
rename C27_5 TASAF_id
rename C27_6 drivers_license
rename C27_7 passport
rename C27_8 elec_water_bill
rename C27_9 phone_bill
rename C27_10 bank_statement
rename C27_11 lease_agreement
rename C27_12 subscription
rename C27_13 tax_id_num
rename C27_14 insurance_policy
rename C27_15 pay_slip
rename C27_16 title_deed
rename C27_17 none
**bank account
rename J1_1_1 use_bank
rename CB2_1_1 own_acct
rename CB2_1_2 joint_acct
**mobile money
rename J1_1_5 use_MM
rename H2_5_1 sent_money_spouse
rename H2_5_2 sent_money_child
rename H2_5_3 sent_money_parent
rename H2_5_4 sent_money_other_fam
rename H2_5_5 sent_money_friend
rename H2_5_6 sent_money_borrowed_from
rename H2_5_7 sent_money_other
rename H5_5_1 receive_money_spouse
rename H5_5_2 receive_money_child
rename H5_5_3 receive_money_parent
rename H5_5_4 receive_money_other_fam
rename H5_5_5 receive_money_friend
rename H5_5_6 receive_money_borrowed_from
rename H5_5_7 receive_money_other

*INDICATORS
**ask advice
rename E3_1 ask_advice_money
rename E3_3 advice_source
**financial services
rename F2 if_save
rename F4_1_3 save_SACCO
rename G2_1_1 if_borrow
rename G5_1_3 borrow_SACCO
rename F4_1_7 save_SG
rename G5_1_11 borrow_SG
**interaction
rename J1_1_4 use_SACCO
rename J1_1_10 use_SG
**confidence
rename F3_2_1_3 SACCO_conf_save 
rename G1_2_1_3 SACCO_conf_borrow 
rename F3_2_1_6 SG_conf_save 
rename G1_2_1_6 SG_conf_borrow
rename F3_2_2 most_conf_save
rename G1_2_2 most_conf_borrow
**SHG activities
rename SC3_2_1 SACCO_funeral
rename SC3_2_2 SACCO_social_event
rename SC3_2_3 SACCO_income
rename SC3_2_4 SACCO_buy_assets
rename SC3_2_5 SACCO_bank_acct
rename SC3_2_6 SACCO_MM_dividends //not in savings group
rename SC3_2_7 SACCO_MM_receive
rename SC3_2_8 SACCO_loan
rename SC3_2_9 SACCO_insurance 
rename SG4_2_1 SG_funeral
rename SG4_2_2 SG_social_event
rename SG4_2_3 SG_income
rename SG4_2_4 SG_buy_assets
rename SG4_2_5 SG_constitution //not in SACCO
rename SG4_2_6 SG_bank_acct
rename SG4_2_7 SG_MMstore //not in SACCO
rename SG4_2_8 SG_MM_receive
rename SG4_2_9 SG_loan 
rename SG4_2_10 SG_insurance
**SACCO why not
rename SC9 why_not_SACCO
*main reason belong
rename SC1_1 SACCO_main_reason
rename SG2 SG_main_reason
*services with a SHG
rename SC3_1_1 SACCO_use_to_save
rename SC3_1_2 SACCO_shares
rename SC3_1_3 SACCO_dividends
rename SC3_1_4 SACCO_borrow_w_int
rename SC3_1_5 SACCO_borrow_wo_int
rename SC3_1_6 SACCO_welfare
rename SC3_1_7 SACCO_farm_inputs
rename SC3_1_8 SACCO_better_price 
rename SG4_1_1 SG_use_to_save
rename SG4_1_2 SG_shares
rename SG4_1_3 SG_borrow_w_int
rename SG4_1_4 SG_borrow_wo_int
rename SG4_1_5 SG_for_emergency
rename SG4_1_6 SG_other_services
rename SG4_1_7 SG_use_insurance
rename SG4_1_8 SG_other_use 

************************
*SET WEIGHTS
************************
svyset [pweight=Final_we]

************************ 
*SEGMENTATION
************************
*rural
gen rural = . 
lab var rural "Respondent lives in a rural location" //Rural = 1, Urban = 0
replace rural = 0 if rural_urban == 2
replace rural = 1 if rural_urban == 1

*sex
gen female = .
lab var female "Sex of respondent" //Female = 1, Male = 0
replace female = 1 if sex == 2
replace female = 0 if sex == 1 
//n=9,459

*poverty
gen two_low_PPI = . 
lab var two_low_PPI "Two lowest PPI Quantiles" //Two lowest quantiles = 1, Else = 0
replace two_low_PPI = 0 if PPI_quantiles == 2 | PPI_quantiles == 3 
replace two_low_PPI = 1 if PPI_quantiles == 1
//n=9,459

gen mid_PPI = .  
lab var mid_PPI "Middle PPI Quantile" //Middle quantile = 1, Else = 0
replace mid_PPI = 0 if PPI_quantiles == 1 | PPI_quantiles == 3
replace mid_PPI = 1 if PPI_quantiles == 2
//n=9,459

gen two_high_PPI = .  
lab var two_high_PPI "Two highest PPI Quantiles" //Two highest quantiles = 1, Else = 0
replace two_high_PPI = 0 if PPI_quantiles == 1 | PPI_quantiles == 2
replace two_high_PPI = 1 if PPI_quantiles == 3
//n=9,459

*mobile phone
gen have_phone = .
lab var have_phone "Respondent has access to a mobile phone" //Yes = 1, No = 0 
replace have_phone = 0 if phone_access == 2 | phone_own == 2
replace have_phone = 1 if phone_access == 1 | phone_own == 1
//n=9,459

*national ID
gen have_id = .
lab var have_id "Respondent has an ID card" //Yes = 1, No = 0 
replace have_id = 0 if ntnl_id_card != -1 | ntnl_id_num != -1 | zanzibar_id != -1 | voter_id != -1 | TASAF_id != -1 | drivers_license != -1 | passport != -1 | elec_water_bill != -1 | /*
*/phone_bill != -1 | bank_statement != -1 | lease_agreement != -1 | subscription != -1 | tax_id_num != -1 | insurance_policy != -1 | pay_slip != -1 | title_deed != -1 | none != -1
replace have_id = 1 if ntnl_id_card == 1 | ntnl_id_num == 1 | zanzibar_id == 1 | voter_id == 1 | TASAF_id == 1 | drivers_license == 1 | passport == 1 
//n=9,459

*bank account
gen have_bank_acct = .
lab var have_bank_acct "Respondent has access to a bank account" //Yes = 1, No = 0
replace have_bank_acct = 0 if use_bank == 2 
replace have_bank_acct = 0 if own_acct != 1 | joint_acct != 1
replace have_bank_acct = 1 if use_bank == 1 & (own_acct == 1 | joint_acct == 1)
//n=9,459

*mobile money 
gen have_used_MM = .
lab var have_used_MM "Respondent has used mobile money" //Yes = 1, No = 0
replace have_used_MM = 0 if use_MM == 2
replace have_used_MM = 1 if use_MM == 1
replace have_used_MM = 1 if sent_money_spouse == 4 | sent_money_spouse == 5 | sent_money_child == 4 | sent_money_child == 5 | sent_money_parent == 4 | sent_money_parent == 5 | sent_money_other_fam == 4 | sent_money_other_fam == 5 |/*
*/ sent_money_friend == 4 | sent_money_friend == 5 | sent_money_borrowed_from == 4 | sent_money_borrowed_from == 5 | sent_money_other == 4 | sent_money_other == 5
replace have_used_MM = 1 if receive_money_spouse == 4 | receive_money_spouse == 5 | receive_money_child == 4 | receive_money_child == 5 | receive_money_parent == 4 | receive_money_parent == 5 | receive_money_other_fam == 4 |/* 
*/receive_money_other_fam == 5 | receive_money_friend == 4 | receive_money_friend == 5 | receive_money_borrowed_from == 4 | receive_money_borrowed_from == 5 | receive_money_other == 4 | receive_money_other == 5
//n=9,459

************
*Proportion of individuals who have received advice about money matters 
************
*Individuals who have received advice from a SACCO
gen SACCO_ask_advice_money = .
lab var SACCO_ask_advice_money "Proportion of individuals who have received advice from a SACCO" //Yes=1, No=0
replace SACCO_ask_advice_money = 0 if ask_advice_money == 2 
replace SACCO_ask_advice_money = 0 if advice_source != 6 & advice_source != -1 
replace SACCO_ask_advice_money = 1 if advice_source == 6 // For source: SACCOs = 6
//n=9,459

*Individuals who have received advice from a farmers association
gen FA_ask_advice_money = .
lab var FA_ask_advice_money "Proportion of individuals who have received advice from a farmers association" //Yes=1, No=0
replace FA_ask_advice_money = 0 if ask_advice_money == 2 
replace FA_ask_advice_money = 0 if advice_source != 8 & advice_source != -1 
replace FA_ask_advice_money = 1 if advice_source == 8 // For source: Farmers assocation = 8
//n=9,459

*Individuals who have received advice from a business association
gen BA_ask_advice_money = .
lab var BA_ask_advice_money "Proportion of individuals who have received advice from a business association" //Yes=1, No=0
replace BA_ask_advice_money = 0 if ask_advice_money == 2 
replace BA_ask_advice_money = 0 if advice_source != 9 & advice_source != -1 
replace BA_ask_advice_money = 1 if advice_source == 9 // For source: Business assocation = 9
//n=9,459

*Individuals who have received advice from a savings group
gen SG_ask_advice_money = .
lab var SG_ask_advice_money "Proportion of individuals who have received advice from a savings group" //Yes=1, No=0
replace SG_ask_advice_money = 0 if ask_advice_money == 2 
replace SG_ask_advice_money = 0 if advice_source != 10 & advice_source != -1 
replace SG_ask_advice_money = 1 if advice_source == 10 // For source: Savings group = 10
//n=9,459

*Individuals who have received advice from any SHG
gen SHG_ask_advice_money = .
lab var SHG_ask_advice_money "Proportion of individuals who have received advice from a self-help group" //Yes=1, No=0
replace SHG_ask_advice_money = 0 if SACCO_ask_advice_money == 0 | FA_ask_advice_money == 0 | BA_ask_advice_money == 0 | SG_ask_advice_money == 0
replace SHG_ask_advice_money = 1 if SACCO_ask_advice_money == 1 | FA_ask_advice_money == 1 | BA_ask_advice_money == 1 | SG_ask_advice_money == 1 
//n=9,459

************
*Proportion of individuals who have used a SHG for financial services 
************
*Individuals who have saved money with a SACCO in the past 12 months
gen SACCO_save_past_12_mos = .
lab var SACCO_save_past_12_mos "Individuals have saved with a SACCO in the past 12 mos"
replace SACCO_save_past_12_mos = 0 if if_save == 2
replace SACCO_save_past_12_mos = 0 if save_SACCO != 1 & save_SACCO != -1 
replace SACCO_save_past_12_mos = 1 if save_SACCO == 1
//n=9,459

*Individuals who have borrowed money with a SACCO in the past 12 months
gen SACCO_borrow_past_12_mos = .
lab var SACCO_borrow_past_12_mos "Individuals have borrowed with a SACCO in the past 12 mos"
replace SACCO_borrow_past_12_mos = 0 if if_borrow == 2
replace SACCO_borrow_past_12_mos = 0 if borrow_SACCO != 1 & borrow_SACCO != -1 
replace SACCO_borrow_past_12_mos = 1 if borrow_SACCO == 1 
//n=9,459

*Full count of individuals who have used a SACCO for financial services
gen SACCO_use_finserv = .
lab var SACCO_use_finserv "Individuals who used a SACCO for financial services " //Yes = 1, No = 0
replace SACCO_use_finserv = 0 if SACCO_save_past_12_mos == 0 | SACCO_borrow_past_12_mos == 0 
replace SACCO_use_finserv = 1 if SACCO_save_past_12_mos == 1 | SACCO_borrow_past_12_mos == 1 
//n=9,459

*Individuals who have saved money with a savings group in the past 12 months
gen SG_save_past_12_mos = .
lab var SG_save_past_12_mos "Individuals have saved with a savings group in the past 12 mos"
replace SG_save_past_12_mos = 0 if if_save == 2
replace SG_save_past_12_mos = 0 if save_SG != 1 & save_SG != -1 
replace SG_save_past_12_mos = 1 if save_SG == 1 
//n=9,459

*Individuals who have borrowed money with a savings group in the past 12 months
gen SG_borrow_past_12_mos = .
lab var SG_borrow_past_12_mos "Individuals have borrowed with a savings group in the past 12 mos"
replace SG_borrow_past_12_mos = 0 if if_borrow == 2
replace SG_borrow_past_12_mos = 0 if borrow_SG != 1 & borrow_SG != -1 
replace SG_borrow_past_12_mos = 1 if borrow_SG == 1 
//n=9,459

*Full count of individuals who have used a savings group for financial services
gen SG_use_finserv = .
lab var SG_use_finserv "Individuals who used a savings group for financial services " //Yes = 1, No = 0
replace SG_use_finserv = 0 if SG_save_past_12_mos == 0 | SG_borrow_past_12_mos == 0 
replace SG_use_finserv = 1 if SG_save_past_12_mos == 1 | SG_borrow_past_12_mos == 1 
//n=9,459

*Full count of individuals who have used a SHG for financial services
gen SHG_use_finserv = .
lab var SHG_use_finserv "Individuals who used a self help group for financial services " //Yes = 1, No = 0
replace SHG_use_finserv = 0 if SACCO_use_finserv == 0 | SG_use_finserv == 0 
replace SHG_use_finserv = 1 if SACCO_use_finserv == 1 | SG_use_finserv == 1
//n=9,459 

************
*Proportion of individuals who have interacted with a SHG 
************
*Individuals who interact with a SACCO sometimes
gen SACCO_use = .  
lab var SACCO_use "Proportion of individuals who sometimes interact with a SACCO"
replace SACCO_use = 0 if use_SACCO == 2
replace SACCO_use = 1 if use_SACCO == 1
//n=9,459

*Individuals who interact with a savings group sometimes
gen SG_use = .
lab var SG_use "Proportion of individuals who sometimes interact with a savings group"
replace SG_use = 0 if use_SG == 2
replace SG_use = 1 if use_SG == 1
//n=9,459

*Full count of individuals who have interacted with a SACCO
gen SACCO_use_all = .
lab var SACCO_use_all "Proportion of individuals who interacted with a SACCO in any way" //Yes=1, No=0
replace SACCO_use_all = 0 if SACCO_ask_advice_money == 0 | SACCO_save_past_12_mos == 0 | SACCO_borrow_past_12_mos == 0 | use_SACCO == 0
replace SACCO_use_all = 1 if SACCO_ask_advice_money == 1 | SACCO_save_past_12_mos == 1 | SACCO_borrow_past_12_mos == 1 | use_SACCO == 1
//n=9,459

*Full count of individuals who have interacted with a savings group
gen SG_use_all = .
lab var SG_use_all "Proportion of individuals who interacted with a savings group in any way" //Yes=1, No=0
replace SG_use_all = 0 if SG_ask_advice_money == 0 | SG_save_past_12_mos == 0 | SG_borrow_past_12_mos == 0 | use_SG == 0
replace SG_use_all = 1 if SG_ask_advice_money == 1 | SG_save_past_12_mos == 1 | SG_borrow_past_12_mos == 1 | use_SG == 1
//n=9,459

*Full count of individuals who have interacted with a SHG
gen SHG_use_all = .
lab var SHG_use_all "Proportion of individuals who interacted with a SHG in any way" //Yes=1, No=0
replace SHG_use_all = 0 if SACCO_use_all == 0 | SG_use_all == 0
replace SHG_use_all = 1 if SACCO_use_all == 1 | SG_use_all == 1
//n=9,459

************
*Proportion of individuals who feel (MOST) confident using a SHG for financial services 
************
*Individuals who feel confident saving with a SACCO
gen SACCO_save_conf = .
lab var SACCO_save_conf "Proportion of individuals who feel confident saving with a SACCO"
replace SACCO_save_conf = 0 if SACCO_conf_save == 2 | SACCO_conf_save == 3
replace SACCO_save_conf = 1 if SACCO_conf_save == 1
//n=9,459

*Individuals who feel confident borrowing with a SACCO
gen SACCO_borrow_conf = .
lab var SACCO_borrow_conf "Proportion of individuals who feel confident borrowing with a SACCO"
replace SACCO_borrow_conf = 0 if SACCO_conf_borrow == 2 | SACCO_conf_borrow == 3 
replace SACCO_borrow_conf = 1 if SACCO_conf_borrow == 1
//n=9,459

*Full count of individuals who feel confident using a SACCO for financial services
gen SACCO_conf_finserv = .
lab var SACCO_conf_finserv "Proportion of individuals who feel confident using a SACCO for financial services" //Yes = 1, No = 0
replace SACCO_conf_finserv = 0 if SACCO_save_conf == 0 | SACCO_borrow_conf == 0 
replace SACCO_conf_finserv = 1 if SACCO_save_conf == 1 | SACCO_borrow_conf == 1
//n=9,459

*Individuals who feel confident saving with a savings group
gen SG_save_conf = . 
lab var SG_save_conf "Proportion of individuals who feel confident saving with a savings group"
replace SG_save_conf = 0 if SG_conf_save == 2 | SG_conf_save == 3
replace SG_save_conf = 1 if SG_conf_save == 1
//n=9,459

*Individuals who feel confident borrowing with a savings group
gen SG_borrow_conf = .
lab var SG_borrow_conf "Proportion of individuals who feel confident borrowing with a savings group"
replace SG_borrow_conf = 0 if SG_conf_borrow == 2 | SG_conf_borrow == 3
replace SG_borrow_conf = 1 if SG_conf_borrow == 1
//n=9,459

*Full count of individuals who feel confident using a savings group for financial services
gen SG_conf_finserv = .
lab var SG_conf_finserv "Proportion of individuals who feel confident using a savings group for financial services" //Yes = 1, No = 0
replace SG_conf_finserv = 0 if SG_save_conf == 0 | SG_borrow_conf == 0 
replace SG_conf_finserv = 1 if SG_save_conf == 1 | SG_borrow_conf == 1
//n=9,459

*Full count of individuals who feel confident using a SHG for financial services
gen SHG_conf_finserv = .
lab var SHG_conf_finserv "Proportion of individuals who feel confident using a SHG for financial services" //Yes = 1, No = 0
replace SHG_conf_finserv = 0 if SG_conf_finserv == 0 | SACCO_conf_finserv == 0  
replace SHG_conf_finserv = 1 if SG_conf_finserv == 1 | SACCO_conf_finserv == 1
//n=9,459

*Individuals feel MOST confident saving with a SACCO
gen SACCO_most_conf_save = .
lab var SACCO_most_conf_save "Proportion of individuals who feel MOST confident saving with a SACCO"
replace SACCO_most_conf_save = 0 if most_conf_save != 3 
replace SACCO_most_conf_save = 1 if most_conf_save == 3 
//n=9,459

*Individuals feel MOST confident borrowing with a SACCO
gen SACCO_most_conf_borrow = .
lab var SACCO_most_conf_borrow "Proportion of individuals who feel MOST confident borrowing with a SACCO"
replace SACCO_most_conf_borrow = 0 if most_conf_borrow != 3 
replace SACCO_most_conf_borrow = 1 if most_conf_borrow == 3 
//n=9,459

*Full count of individuals who feel MOST confident using a SACCO for financial services
gen SACCO_most_conf_finserv = .
lab var SACCO_most_conf_finserv "Feel MOST confident using a SACCO for financial services" //Yes = 1, No = 0
replace SACCO_most_conf_finserv = 0 if SACCO_most_conf_save == 0 | SACCO_most_conf_borrow == 0 
replace SACCO_most_conf_finserv = 1 if SACCO_most_conf_save == 1 | SACCO_most_conf_borrow == 1
//n=9,459

*Individuals feel MOST confident saving with a savings group
gen SG_most_conf_save = .
lab var SG_most_conf_save "Proportion of individuals who feel MOST confident saving with a savings group"
replace SG_most_conf_save = 0 if most_conf_save != 6
replace SG_most_conf_save = 1 if most_conf_save == 6
//n=9,459

*Individuals feel MOST confident borrowing with a savings group
gen SG_most_conf_borrow = .
lab var SG_most_conf_borrow "Proportion of individuals who feel MOST confident borrowing with a savings group"
replace SG_most_conf_borrow = 0 if most_conf_borrow != 6
replace SG_most_conf_borrow = 1 if most_conf_borrow == 6
//n=9,459

*Full count of individuals who feel MOST confident using a savings group for financial services
gen SG_most_conf_finserv = .
lab var SG_most_conf_finserv "Feel MOST confident using a savings group for financial services" //Yes = 1, No = 0
replace SG_most_conf_finserv = 0 if SG_most_conf_save == 0 | SG_most_conf_borrow == 0 
replace SG_most_conf_finserv = 1 if SG_most_conf_save == 1 | SG_most_conf_borrow == 1
//n=9,459

*Individuals feel MOST confident saving with a SHG
gen SHG_most_conf_save = .
lab var SHG_most_conf_save "Proportion of individuals who feel MOST confident saving with a SACCO"
replace SHG_most_conf_save = 0 if SACCO_most_conf_save == 0 | SG_most_conf_save == 0
replace SHG_most_conf_save = 1 if SACCO_most_conf_save == 1 | SG_most_conf_save == 1
//n=9,459

*Individuals feel MOST confident borrowing with a SHG
gen SHG_most_conf_borrow = .
lab var SHG_most_conf_borrow "Proportion of individuals who feel MOST confident borrowing with a SACCO"
replace SHG_most_conf_borrow = 0 if SACCO_most_conf_borrow == 0 | SG_most_conf_borrow == 0
replace SHG_most_conf_borrow = 1 if SACCO_most_conf_borrow == 1 | SG_most_conf_borrow == 1
//n=9,459

*Full count of individuals who feel MOST confident using a SHG for financial services
gen SHG_most_conf_finserv = .
lab var SHG_most_conf_finserv "Feel MOST confident using a SHG for financial services" //Yes = 1, No = 0
replace SHG_most_conf_finserv = 0 if SHG_most_conf_save == 0 | SHG_most_conf_borrow == 0 
replace SHG_most_conf_finserv = 1 if SHG_most_conf_save == 1 | SHG_most_conf_borrow == 1
//n=9,459

************
*Counts of SHG activities
************ 
*SACCO Actvities
gen funeral_SACCO = . 
lab var funeral_SACCO "Proportion of individuals that belong to a SACCO that contributes towards funerals or other emergencies of members and their families"
replace funeral_SACCO = . if SACCO_funeral == -1 
replace funeral_SACCO = 0 if SACCO_funeral == 2 | SACCO_funeral == 3 
replace funeral_SACCO = 1 if SACCO_funeral == 1
//n=133 (number of individuals who sometimes use SACCOs)

gen social_event_SACCO = .  
lab var social_event_SACCO "Proportion of individuals that belong to a SACCO that contributes towards social events of members (e.g. weddings, birth of a child)"
replace social_event_SACCO = . if SACCO_social_event == -1 
replace social_event_SACCO = 0 if SACCO_social_event == 2 | SACCO_social_event == 3 
replace social_event_SACCO = 1 if SACCO_social_event == 1
//n=133 (number of individuals who sometimes use SACCOs)

gen income_SACCO = . 
lab var income_SACCO "Proportion of individuals that belong to a SACCO that has a joint income generating activity"
replace income_SACCO = . if SACCO_income == -1 
replace income_SACCO = 0 if SACCO_income == 2 | SACCO_income == 3 
replace income_SACCO = 1 if SACCO_income == 1
//n=133 (number of individuals who sometimes use SACCOs)

gen buy_assets_SACCO = . 
lab var buy_assets_SACCO "Proportion of individuals that belong to a SACCO that buys assets for members"
replace buy_assets_SACCO = . if SACCO_buy_assets == -1 
replace buy_assets_SACCO = 0 if SACCO_buy_assets == 2 | SACCO_buy_assets == 3 
replace buy_assets_SACCO = 1 if SACCO_buy_assets == 1
//n=133 (number of individuals who sometimes use SACCOs)

gen bank_acct_SACCO = . 
lab var bank_acct_SACCO "Proportion of individuals that belong to a SACCO that has a bank account"
replace bank_acct_SACCO = . if SACCO_bank_acct == -1 
replace bank_acct_SACCO = 0 if SACCO_bank_acct == 2 | SACCO_bank_acct == 3 
replace bank_acct_SACCO = 1 if SACCO_bank_acct == 1
//n=133 (number of individuals who sometimes use SACCOs)

gen MM_dividends_SACCO = . 
lab var MM_dividends_SACCO "Proportion of individuals that belong to a SACCO that uses mobile money services for paying out dividends" //not in savings group Qs
replace MM_dividends_SACCO = . if SACCO_MM_dividends == -1 
replace MM_dividends_SACCO = 0 if SACCO_MM_dividends == 2 | SACCO_MM_dividends == 3 
replace MM_dividends_SACCO = 1 if SACCO_MM_dividends == 1
//n=133 (number of individuals who sometimes use SACCOs)

gen MM_receive_SACCO = . 
lab var MM_receive_SACCO "Proportion of individuals that belong to a SACCO that uses mobile money services to receive member money"
replace MM_receive_SACCO = . if SACCO_MM_receive == -1 
replace MM_receive_SACCO = 0 if SACCO_MM_receive == 2 | SACCO_MM_receive == 3 
replace MM_receive_SACCO = 1 if SACCO_MM_receive == 1
//n=133 (number of individuals who sometimes use SACCOs)

gen loan_SACCO = . 
lab var loan_SACCO "Proportion of individuals that belong to a SACCO that has a loan from a bank"
replace loan_SACCO = . if SACCO_loan == -1 
replace loan_SACCO = 0 if SACCO_loan == 2 | SACCO_loan == 3 
replace loan_SACCO = 1 if SACCO_loan == 1
//n=133 (number of individuals who sometimes use SACCOs)

gen insurance_SACCO = . 
lab var insurance_SACCO "Proportion of individuals that belong to a SACCO that has insurance"
replace insurance_SACCO = . if SACCO_insurance == -1 
replace insurance_SACCO = 0 if SACCO_insurance == 2 | SACCO_insurance == 3 
replace insurance_SACCO = 1 if SACCO_insurance == 1
//n=133 (number of individuals who sometimes use SACCOs)

*Savings group activities 
gen funeral_SG = .
lab var funeral_SG "Proportion of individuals that belong to a savings group that contributes towards funerals or other emergencies of members and their families"
replace funeral_SG = . if SG_funeral == -1 
replace funeral_SG = 0 if SG_funeral == 2 | SG_funeral == 3 
replace funeral_SG = 1 if SG_funeral == 1

gen social_event_SG = .
lab var social_event_SG "Proportion of individuals that belong to a savings group that contributes towards social events of members (e.g. weddings, birth of a child)"
replace social_event_SG = . if SG_social_event == -1 
replace social_event_SG = 0 if SG_social_event == 2 | SG_social_event == 3 
replace social_event_SG = 1 if SG_social_event == 1

gen income_SG = .
lab var income_SG "Proportion of individuals that belong to a savings group that has a joint income generating activity"
replace income_SG = . if SG_income == -1 
replace income_SG = 0 if SG_income == 2 | SG_income == 3 
replace income_SG = 1 if SG_income == 1

gen buy_assets_SG = .
lab var buy_assets_SG "Proportion of individuals that belong to a savings group that buys assets for members"
replace buy_assets_SG = . if SG_buy_assets == -1 
replace buy_assets_SG = 0 if SG_buy_assets == 2 | SG_buy_assets == 3 
replace buy_assets_SG = 1 if SG_buy_assets == 1

gen constitution_SG = .
lab var constitution_SG "Proportion of individuals that belong to a savings group that has a constitution" //not in SACCO
replace constitution_SG = . if SG_constitution == -1 
replace constitution_SG = 0 if SG_constitution == 2 | SG_constitution == 3 
replace constitution_SG = 1 if SG_constitution == 1

gen bank_acct_SG = .
lab var bank_acct_SG "Proportion of individuals that belong to a savings group that has a bank account"
replace bank_acct_SG = 0 if SG_bank_acct == 2 | SG_bank_acct == 3 
replace bank_acct_SG = . if SG_bank_acct == -1 
replace bank_acct_SG = 1 if SG_bank_acct == 1

gen MMstore_SG = .
lab var MMstore_SG "Proportion of individuals that belong to a savings group that uses mobile money to store members money" //not in SACCO
replace MMstore_SG = . if SG_MMstore == -1 
replace MMstore_SG = 0 if SG_MMstore == 2 | SG_MMstore == 3 
replace MMstore_SG = 1 if SG_MMstore == 1

gen MMreceive_SG = .
lab var MMreceive_SG "Proportion of individuals that belong to a savings group that uses mobile money services to receive member money"
replace MMreceive_SG = . if SG_MM_receive == -1 
replace MMreceive_SG = 0 if SG_MM_receive == 2 | SG_MM_receive == 3 
replace MMreceive_SG = 1 if SG_MM_receive == 1

gen loan_SG = .
lab var loan_SG "Proportion of individuals that belong to a savings group that has a loan from a bank"
replace loan_SG = . if SG_loan == -1 
replace loan_SG = 0 if SG_loan == 2 | SG_loan == 3 
replace loan_SG = 1 if loan_SG == 1

gen insurance_SG = .
lab var SG_insurance "Proportion of individuals that belong to a savings group that has insurance"
replace insurance_SG = . if SG_insurance == -1 
replace insurance_SG = 0 if SG_insurance == 2 | SG_insurance == 3 
replace insurance_SG = 1 if SG_insurance == 1

*SHG activities 
gen SHG_funeral = .
lab var SHG_funeral "Proportion of individuals that belong to a SHG that contributes towards funerals or other emergencies of members and their families"
replace SHG_funeral = 0 if funeral_SACCO == 0 | funeral_SG == 0
replace SHG_funeral = 1 if funeral_SACCO == 1 | funeral_SG == 1

gen SHG_social_event = .
lab var SHG_social_event "Proportion of individuals that belong to a SHG that contributes towards social events of members (e.g. weddings, birth of a child)"
replace SHG_social_event = 0 if social_event_SACCO == 0 | social_event_SG == 0
replace SHG_social_event = 1 if social_event_SACCO == 1 | social_event_SG == 1

gen SHG_income = .
lab var SHG_income "Proportion of individuals that belong to a SHG that has a joint income generating activity"
replace SHG_income = 0 if income_SACCO == 0 | income_SG == 0
replace SHG_income = 1 if income_SACCO == 1 | income_SG == 1

gen SHG_buy_assets = .
lab var SHG_buy_assets "Proportion of individuals that belong to a SHG that buys assets for members"
replace SHG_buy_assets = 0 if buy_assets_SACCO == 0 | buy_assets_SG == 0
replace SHG_buy_assets = 1 if buy_assets_SACCO == 1 | buy_assets_SG == 1

gen SHG_bank_acct = .
lab var SHG_bank_acct "Proportion of individuals that belong to a SHG that has a bank account"
replace SHG_bank_acct = 0 if bank_acct_SACCO == 0 | bank_acct_SG == 0
replace SHG_bank_acct = 1 if bank_acct_SACCO == 1 | bank_acct_SG == 1

gen SHG_MM_receive = .
lab var SHG_MM_receive "Proportion of individuals that belong to a SHG that uses mobile money services to receive member money"
replace SHG_MM_receive = 0 if MM_receive_SACCO == 0 | MMreceive_SG == 0
replace SHG_MM_receive = 1 if MM_receive_SACCO == 1 | MMreceive_SG == 1

gen SHG_loan = .
lab var SHG_loan "Proportion of individuals that belong to a SHG that has a loan from a bank"
replace SHG_loan = 0 if loan_SACCO == 0 | loan_SG == 0
replace SHG_loan = 1 if loan_SACCO == 1 | loan_SG == 1

gen SHG_insurance = .
lab var SHG_insurance "Proportion of individuals that belong to a SHG that has insurance"
replace SHG_insurance = 0 if insurance_SACCO == 0 | insurance_SG == 0
replace SHG_insurance = 1 if insurance_SACCO == 1 | insurance_SG == 1

*overall belong
gen belong_SHG = .
lab var belong_SHG "Proportion of respondents that belong to a SHG"
replace belong_SHG = 0 if use_SACCO != 1 & use_SG != 1
replace belong_SHG = 1 if use_SACCO == 1 | use_SG == 1

************
*Counts of SACCO why not
************ 
gen notSACCO_dont_know = .
lab var notSACCO_dont_know "Do not know SACCOs"
replace notSACCO_dont_know = 0 if why_not_SACCO != 1 & why_not_SACCO != -1
replace notSACCO_dont_know = 1 if why_not_SACCO == 1

gen notSACCO_dont_know_comm = .
lab var notSACCO_dont_know_comm "Do not know of SACCOs in my community"
replace notSACCO_dont_know_comm = 0 if why_not_SACCO != 2 & why_not_SACCO != -1
replace notSACCO_dont_know_comm = 1 if why_not_SACCO == 2

gen notSACCO_fee = .
lab var notSACCO_fee "Do not have the joining/membership fee"
replace notSACCO_fee = 0 if why_not_SACCO != 3 & why_not_SACCO != -1
replace notSACCO_fee = 1 if why_not_SACCO == 3

gen notSACCO_no_benefits = .
lab var notSACCO_no_benefits "They do not offer me any benefits"
replace notSACCO_no_benefits = 0 if why_not_SACCO != 4 & why_not_SACCO != -1
replace notSACCO_no_benefits = 1 if why_not_SACCO == 4

gen notSACCO_dont_trust = .
lab var notSACCO_dont_trust "Do not trust them"
replace notSACCO_dont_trust = 0 if why_not_SACCO != 5 & why_not_SACCO != -1
replace notSACCO_dont_trust = 1 if why_not_SACCO == 5

gen notSACCO_elsewhere = .
lab var notSACCO_elsewhere "I can get the services they offer elsewhere"
replace notSACCO_elsewhere = 0 if why_not_SACCO != 6 & why_not_SACCO != -1
replace notSACCO_elsewhere = 1 if why_not_SACCO == 6

gen notSACCO_no_reason = .
lab var notSACCO_no_reason "No specific reason"
replace notSACCO_no_reason = 0 if why_not_SACCO != 7 & why_not_SACCO != -1
replace notSACCO_no_reason = 1 if why_not_SACCO == 7

gen notSACCO_other = .
lab var notSACCO_other "Other"
replace notSACCO_other = 0 if why_not_SACCO != 8 & why_not_SACCO != -1
replace notSACCO_other = 1 if why_not_SACCO == 8

************
*Counts of main reasons for belonging to a SHG 
************
*Proportion of individuals who belong to a SACCO for each reason
gen SACCO_socialize = .
lab var SACCO_socialize "Belong to SACCO to socialize or meet friends/to network"
replace SACCO_socialize = 0 if SACCO_main_reason != 1  & SACCO_main_reason != -1
replace SACCO_socialize = 1 if SACCO_main_reason == 1 

gen SACCO_fin_advice = .
lab var SACCO_fin_advice "Belong to SACCO because they give financial advice"
replace SACCO_fin_advice = 0 if SACCO_main_reason != 2 & SACCO_main_reason != -1
replace SACCO_fin_advice = 1 if SACCO_main_reason == 2

gen SACCO_info = .
lab var SACCO_info "Belong to SACCO because they give information on matters such as education, health, etc."
replace SACCO_info = 0 if SACCO_main_reason != 3 & SACCO_main_reason != -1
replace SACCO_info = 1 if SACCO_main_reason == 3

gen SACCO_fin_need = .
lab var SACCO_fin_need "Belong to SACCO because I can turn to them when in financial need"
replace SACCO_fin_need = 0 if SACCO_main_reason != 4 & SACCO_main_reason != -1
replace SACCO_fin_need = 1 if SACCO_main_reason == 4

gen SACCO_emergency = .
lab var SACCO_emergency "Belong to SACCO because I can get access to money in case of loss or emergency/access the social fund"
replace SACCO_emergency = 0 if SACCO_main_reason != 5 & SACCO_main_reason != -1
replace SACCO_emergency = 1 if SACCO_main_reason == 5

gen SACCO_borrow = .
lab var SACCO_borrow "Belong to SACCO to borrow money"
replace SACCO_borrow = 0 if SACCO_main_reason != 6 & SACCO_main_reason != -1
replace SACCO_borrow = 1 if SACCO_main_reason == 6

gen SACCO_save = .
lab var SACCO_save "Belong to SACCO because to save money/to buy shares"
replace SACCO_save = 0 if SACCO_main_reason != 7 & SACCO_main_reason != -1
replace SACCO_save = 1 if SACCO_main_reason == 7

gen SACCO_trust = .
lab var SACCO_trust "Belong to SACCO because I trust the members with my money"
replace SACCO_trust = 0 if SACCO_main_reason != 8 & SACCO_main_reason != -1
replace SACCO_trust = 1 if SACCO_main_reason == 8

gen SACCO_inherited = .
lab var SACCO_inherited "Belong to SACCO because I inherited membership"
replace SACCO_inherited = 0 if SACCO_main_reason != 9 & SACCO_main_reason != -1
replace SACCO_inherited = 1 if SACCO_main_reason == 9

gen SACCO_compulsory = .
lab var SACCO_compulsory "Belong to SACCO because it is compulsory/expected of me"
replace SACCO_compulsory = 0 if SACCO_main_reason != 10 & SACCO_main_reason != -1
replace SACCO_compulsory = 1 if SACCO_main_reason == 10

gen SACCO_forces_save = .
lab var SACCO_forces_save "Belong to SACCO because it forces me to save"
replace SACCO_forces_save = 0 if SACCO_main_reason != 11 & SACCO_main_reason != -1
replace SACCO_forces_save = 1 if SACCO_main_reason == 11

gen SACCO_other = .
lab var SACCO_other "Belong to SACCO for another reason"
replace SACCO_other = 0 if SACCO_main_reason != 12 & SACCO_main_reason != -1
replace SACCO_other = 1 if SACCO_main_reason == 12

*Proportion of individuals who belong to a savings group for each reason
gen SG_socialize = .
lab var SG_socialize "Belong to a savings group to socialize or meet friends/to network"
replace SG_socialize = 0 if SG_main_reason != 1 & SG_main_reason != -1
replace SG_socialize = 1 if SG_main_reason == 1 

gen SG_fin_advice = .
lab var SG_fin_advice "Belong to a savings group because they give financial advice"
replace SG_fin_advice = 0 if SG_main_reason != 2 & SG_main_reason != -1
replace SG_fin_advice = 1 if SG_main_reason == 2

gen SG_info = .
lab var SG_info "Belong to a savings group because they give information on matters such as education, health, etc."
replace SG_info = 0 if SG_main_reason != 3 & SG_main_reason != -1
replace SG_info = 1 if SG_main_reason == 3

gen SG_fin_need = .
lab var SG_fin_need "Belong to a savings group because I can turn to them when in financial need"
replace SG_fin_need = 0 if SG_main_reason != 4 & SG_main_reason != -1
replace SG_fin_need = 1 if SG_main_reason == 4

gen SG_emergency = .
lab var SG_emergency "Belong to a savings group because I can get access to money in case of loss or emergency/access the social fund"
replace SG_emergency = 0 if SG_main_reason != 5 & SG_main_reason != -1
replace SG_emergency = 1 if SG_main_reason == 5

gen SG_borrow = .
lab var SG_borrow "Belong to a savings group to borrow money"
replace SG_borrow = 0 if SG_main_reason != 6 & SG_main_reason != -1
replace SG_borrow = 1 if SG_main_reason == 6

gen SG_save = .
lab var SG_save "Belong to a savings group to save money/buy shares"
replace SG_save = 0 if SG_main_reason != 7 & SG_main_reason != -1
replace SG_save = 1 if SG_main_reason == 7

gen SG_trust = .
lab var SG_trust "Belong to a savings group because I trust the members with my money"
replace SG_trust = 0 if SG_main_reason != 8 & SG_main_reason != -1
replace SG_trust = 1 if SG_main_reason == 8

gen SG_inherited = .
lab var SG_inherited "Belong to a savings group because I inherited membership"
replace SG_inherited = 0 if SG_main_reason != 9 & SG_main_reason != -1
replace SG_inherited = 1 if SG_main_reason == 9

gen SG_compulsory = .
lab var SG_compulsory "Belong to a savings group because it is compulsory/expected of me"
replace SG_compulsory = 0 if SG_main_reason != 10 & SG_main_reason != -1
replace SG_compulsory = 1 if SG_main_reason == 10

gen SG_forces_save = .
lab var SG_forces_save "Belong to a savings group because it forces me to save"
replace SG_forces_save = 0 if SG_main_reason != 11 & SG_main_reason != -1
replace SG_forces_save = 1 if SG_main_reason == 11

gen SG_other_reason = .
lab var SG_other_reason "Belong to a savings group for another reason"
replace SG_other_reason = 0 if SG_main_reason != 12 & SG_main_reason != -1
replace SG_other_reason = 1 if SG_main_reason == 12

************
*Counts of services conducted with a SHG
************ 
*SACCO services
lab var SACCO_use_to_save "Save with their SACCO"
replace SACCO_use_to_save = . if SACCO_use_to_save == -1
replace SACCO_use_to_save = 0 if SACCO_use_to_save == 2 
replace SACCO_use_to_save = 1 if SACCO_use_to_save == 1

lab var SACCO_shares "Buy shares with their SACCO"
replace SACCO_shares = . if SACCO_shares == -1
replace SACCO_shares = 0 if SACCO_shares == 2
replace SACCO_shares = 1 if SACCO_shares == 1

lab var SACCO_borrow_w_int "Borrow with interest from their SACCO"
replace SACCO_borrow_w_int = . if SACCO_borrow_w_int == -1 
replace SACCO_borrow_w_int = 0 if SACCO_borrow_w_int == 2 
replace SACCO_borrow_w_int = 1 if SACCO_borrow_w_int == 1

lab var SACCO_borrow_wo_int "Borrow without interest from their SACCO"
replace SACCO_borrow_wo_int = . if SACCO_borrow_wo_int == -1
replace SACCO_borrow_wo_int = 0 if SACCO_borrow_wo_int == 2
replace SACCO_borrow_wo_int = 1 if SACCO_borrow_wo_int == 1

lab var SACCO_dividends "Earn dividends with their SACCO"
replace SACCO_dividends = . if SACCO_dividends == -1
replace SACCO_dividends = 0 if SACCO_dividends == 2 
replace SACCO_dividends = 1 if SACCO_dividends == 1

lab var SACCO_welfare "Access the welfare/social fund with their SACCO"
replace SACCO_welfare = . if SACCO_welfare == -1
replace SACCO_welfare = 0 if SACCO_welfare == 2 
replace SACCO_welfare = 1 if SACCO_welfare == 1 

lab var SACCO_farm_inputs "Use their SACCO to help them get farm inputs"
replace SACCO_farm_inputs = . if SACCO_farm_inputs == -1
replace SACCO_farm_inputs = 0 if SACCO_farm_inputs == 2 
replace SACCO_farm_inputs = 1 if SACCO_farm_inputs == 1

lab var SACCO_better_price "Use their SACCO to help them get a better price for their produce/products"
replace SACCO_better_price = . if SACCO_better_price == -1
replace SACCO_better_price = 0 if SACCO_better_price == 2
replace SACCO_better_price = 1 if SACCO_better_price == 1

*Savings group services
lab var SG_use_to_save "Save with their savings group"
replace SG_use_to_save = . if SG_use_to_save == -1
replace SG_use_to_save = 0 if SG_use_to_save == 2 
replace SG_use_to_save = 1 if SG_use_to_save == 1

lab var SG_shares "Buy shares with their savings group"
replace SG_shares = . if SG_shares == -1
replace SG_shares = 0 if SG_shares == 2 
replace SG_shares = 1 if SG_shares == 1

lab var SG_borrow_w_int "Borrow with interest from their savings group"
replace SG_borrow_w_int = . if SG_borrow_w_int == -1
replace SG_borrow_w_int = 0 if SG_borrow_w_int == 2 
replace SG_borrow_w_int = 1 if SG_borrow_w_int == 1

lab var SG_borrow_wo_int "Borrow without interest from their savings group"
replace SG_borrow_wo_int = . if SG_borrow_wo_int == -1
replace SG_borrow_wo_int = 0 if SG_borrow_wo_int == 2 
replace SG_borrow_wo_int = 1 if SG_borrow_wo_int == 1

lab var SG_for_emergency "Go to their savings group for money when they have an emergency or a social event such as weddings and funerals"
replace SG_for_emergency = . if SG_for_emergency == -1
replace SG_for_emergency = 0 if SG_for_emergency == 2
replace SG_for_emergency = 1 if SG_for_emergency == 1

lab var SG_use_insurance "Use their savings group for insurance services"
replace SG_use_insurance = . if SG_use_insurance == -1
replace SG_use_insurance = 0 if SG_use_insurance == 2
replace SG_use_insurance = 1 if SG_use_insurance == 1

gen SG_other = .
lab var SG_other "Use their savings group for other services"
replace SG_other = . if SG_other_services == -1 | SG_other_use == -1 
replace SG_other = 0 if SG_other_services == 2 | SG_other_use == 2 
replace SG_other = 1 if SG_other_services == 1 | SG_other_use == 1 

*SHG services
gen SHG_save = .
lab var SHG_save "Save with their SHG"
replace SHG_save = 0 if SACCO_save == 0 | SG_save == 0 
replace SHG_save = 1 if SACCO_save == 1 | SG_save == 1

gen SHG_shares = .
lab var SHG_shares "Buy shares with their SHG"
replace SHG_shares = 0 if SACCO_shares == 0 | SG_shares == 0 
replace SHG_shares = 1 if SACCO_shares == 1 | SG_shares == 1

gen SHG_borrow_w_int = .
lab var SHG_borrow_w_int "Borrow with interest from their SHG"
replace SHG_borrow_w_int = 0 if SACCO_borrow_w_int == 0 | SG_borrow_w_int == 0
replace SHG_borrow_w_int = 1 if SACCO_borrow_w_int == 1 | SG_borrow_w_int == 1

gen SHG_borrow_wo_int = .
lab var SHG_borrow_wo_int "Borrow without interest from their SHG"
replace SHG_borrow_wo_int = 0 if SACCO_borrow_wo_int == 0 | SG_borrow_wo_int == 0 
replace SHG_borrow_wo_int = 1 if SACCO_borrow_wo_int == 1 | SG_borrow_wo_int == 1

**Generate Inverse Disaggregator Variables 

gen male = .
replace male = 1 if female == 0
replace male = 0 if female ==1

gen urban = .
replace urban = 1 if rural == 0
replace urban = 0 if rural ==1

gen no_MM_use = .
replace no_MM_use = 1 if have_used_MM == 0
replace no_MM_use = 0 if have_used_MM ==1

gen no_phone = .
replace no_phone = 1 if have_phone == 0
replace no_phone = 0 if have_phone ==1

gen no_id = .
replace no_id = 1 if have_id == 0
replace no_id = 0 if have_id ==1

gen no_bank_acct = .
replace no_bank_acct = 1 if have_bank_acct == 0
replace no_bank_acct = 0 if have_bank_acct ==1

gen SHG_no_use = .
lab var SHG_no_use "Proportion of individuals who have not interacted with a SHG (Among all question respondents)"
replace SHG_no_use = 0 if SHG_use_all == 1
replace SHG_no_use = 1 if SHG_use_all == 0

*Saving
save "$created_data\TZ_FinScope_final.dta", replace


************
*Disaggregate and Export
************ 
use "$created_data\TZ_FinScope_final.dta", clear

*create global of characteristic indicators
global char_indicators SACCO_conf_finserv SG_conf_finserv SHG_conf_finserv SACCO_most_conf_finserv /*
*/ SG_most_conf_finserv SHG_most_conf_finserv funeral_SACCO social_event_SACCO income_SACCO buy_assets_SACCO bank_acct_SACCO MM_dividends_SACCO /*
*/ MM_receive_SACCO loan_SACCO insurance_SACCO funeral_SG social_event_SG income_SG buy_assets_SG constitution_SG bank_acct_SG MMstore_SG MMreceive_SG /*
*/ loan_SG insurance_SG SHG_funeral SHG_social_event SHG_income SHG_buy_assets SHG_bank_acct SHG_MM_receive SHG_loan SHG_insurance /*
*/ notSACCO_dont_know notSACCO_dont_know_comm notSACCO_fee notSACCO_no_benefits notSACCO_dont_trust notSACCO_elsewhere notSACCO_no_reason notSACCO_other /*
*/ SACCO_socialize SACCO_fin_advice  SACCO_info SACCO_fin_need SACCO_emergency SACCO_borrow SACCO_save SACCO_trust SACCO_inherited SACCO_compulsory /*
*/ SACCO_forces_save SACCO_other SG_socialize SG_fin_advice SG_info SG_fin_need SG_emergency SG_borrow  SG_save SG_trust SG_inherited SG_compulsory /*
*/ SG_forces_save SG_other_reason SACCO_use_to_save SACCO_shares SACCO_borrow_w_int SACCO_borrow_wo_int SACCO_dividends SACCO_welfare SACCO_farm_inputs /*
*/ SACCO_better_price SG_use_to_save SG_shares SG_borrow_w_int SG_borrow_wo_int SG_for_emergency SG_use_insurance SG_other SHG_save SHG_shares SHG_borrow_w_int SHG_borrow_wo_int 

*create global of coverage indicators
global coverage_indicators SACCO_ask_advice_money FA_ask_advice_money BA_ask_advice_money SG_ask_advice_money SHG_ask_advice_money /*
*/ SACCO_use_finserv SG_use_finserv SHG_use_finserv SACCO_use_all SG_use_all SHG_use_all 

*create global of disaggregators
global disaggregation female rural two_low_PPI mid_PPI two_high_PPI have_used_MM have_phone have_id have_bank_acct

*Create global of users vs. non-user indicators
	*Business Association, Farmer's Association, SACCO, Savings Group
	gen BA_use_all = BA_ask_advice_money
	gen FA_use_all = FA_ask_advice_money
	gen BA_no_use = .
	replace BA_no_use = 1 if BA_use_all == 0
	replace BA_no_use = 0 if BA_use_all == 1
	gen FA_no_use = .
	replace FA_no_use = 1 if FA_use_all == 0
	replace FA_no_use = 0 if FA_use_all == 1
	gen SG_no_use = .
	replace SG_no_use = 1 if SG_use_all == 0
	replace SG_no_use = 0 if SG_use_all == 1
	gen SACCO_no_use = .
	replace SACCO_no_use = 1 if SACCO_use_all == 0
	replace SACCO_no_use = 0 if SACCO_use_all == 1	
	
global user_nonusers SHG_use_all SHG_no_use SHG_use_finserv SG_use_finserv SG_use_all SG_no_use SACCO_use_finserv SACCO_use_all SACCO_no_use BA_use_all BA_no_use FA_use_all FA_no_use 

*Create global of country demographics
global country_demographics female male rural urban two_low_PPI mid_PPI two_high_PPI have_used_MM no_MM_use have_phone no_phone have_id no_id have_bank_acct no_bank_acct

*Create global of user/non-user disaggregators
global disagg_user_nonuser female male rural urban two_low_PPI mid_PPI two_high_PPI have_used_MM no_MM_use have_phone no_phone have_id no_id have_bank_acct no_bank_acct

*Coverage indicators
putexcel set "$final_data\TZ_FinScope_estimates.xls", modify sheet("Coverage", replace)

svyset [pweight=Final_we] //We can't specify the correct strata and cluster units here which may affect the SE and CI
local row=2 //Start export into row 2

foreach v of global coverage_indicators {
	quietly svy: mean `v'
	matrix prev_estimates=r(table)'
	matselrc prev_estimates mean_se, c(1 2 5 6) //need to install this package if Stata doesn't recognize this command
	putexcel 	A`row'="FinScope" C`row'="Coverage" I`row'="1.4 All individuals" ///
				L`row'="`v'" M`row'=matrix(mean_se) Q`row'=(e(N))
	local ++row
}	
		
foreach v of global coverage_indicators {		
	foreach x of global disaggregation {		
		forvalues i = 0/1 {
			quietly svy, subpop(if `x'==`i'): mean `v'
			matrix prev_estimates=r(table)'
			matselrc prev_estimates mean_se, c(1 2 5 6)
			putexcel 	A`row'="FinScope" C`row'="Coverage" I`row'="`x'=`i'" ///
						L`row'="`v'" M`row'=matrix(mean_se) Q`row'=(e(N_sub))
			local ++row
		}
	}	
}

*Characteristics indicators
putexcel set "$final_data\TZ_FinScope_estimates.xls", modify sheet("Characteristics", replace)

svyset [pweight=Final_we] //We can't specify the correct strata and cluster units here which may affect the SE and CI
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
putexcel set "$final_data\TZ_Finscope_estimates.xls", modify sheet("Users vs. Non-Users", replace)

svyset [pweight=Final_we] //We can't specify the correct strata and cluster units here which may affect the SE and CI
local row=2 //Start export into row 2
		
foreach v of global disagg_user_nonuser {		
	foreach x of global user_nonusers {		
			quietly svy, subpop(if `x'==1): mean `v'
			matrix prev_estimates=r(table)'
			matselrc prev_estimates mean_se, c(1 2 5 6)
			putexcel 	A`row'="Tanzania" C`row'="FinScope" E`row'="Proportion of individuals who exhibit each characteristic" ///
						F`row'="`x'" H`row'="`v'=1" I`row'=matrix(mean_se) M`row'=(e(N_sub))
			local ++row
	}	
}



*Country Demographics indicators
putexcel set "$final_data\TZ_FinScope_estimates.xls", modify sheet("Country Demographics", replace)

svyset [pweight=Final_we] //We can't specify the correct strata and cluster units here which may affect the SE and CI
local row=2 //Start export into row 2
		
foreach x of global country_demographics {		
			quietly svy : mean `x'
			matrix prev_estimates=r(table)'
			matselrc prev_estimates mean_se, c(1 2 5 6)
			putexcel 	A`row'="FinScope" C`row'="Demographics" I`row'="`x'=`1'" ///
						L`row'="`v'" M`row'=matrix(mean_se) Q`row'=(e(N))
			local ++row
		
}

