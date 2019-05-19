
/*---------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	: This do.file was developed by the Evans School Policy Analysis & Research Group (EPAR) 
				  for the construction of indicators related to Coverage and Characteristics of Self-Help Groups using the
				  Kenya FinAccess survey Wave 4 (2016) 													
*Author(s)		: Pierre Biscaye, Kirby Callaway, Elan Ebeling, Annie Rose Favreau, Mel Howlett, 
				  Daniel Lunchik-Seymour, Emily Morton, Kels Phelps,
				  C. Leigh Anderson & Travis Reynolds

				*Acknowledgments: We acknowledge the helpful contributions of members of the Bill & Melinda Gates Foundation Gender Equality team in 
				 discussing indicator construction decisions. All coding errors remain ours alone.
				 
*Date			: 13 July 2018
----------------------------------------------------------------------------------------------------------------------------------------------------*/

*Data source
*-----------
*The Kenya FinAccess household survey was collected by the Central Bank of Kenya (CBK),
*the Kenya National Bureau of Statistics (KNBS), and the Financial Sector Deepening Kenya (FSD Kenya)
*over the period August - October 2015.
*All the raw data, questionnaires, and basic information documents are available for free for download from the 
*FSD Kenya website: http://fsdkenya.org/dataset/finaccess-household-2016/

*Summary of executing the Master do.file
*-----------
*This master do file constructs selected indicators using the Kenya FinAccess data set.
*Using a data file from within the "Raw Data" folder within the "FinScope" folder, 
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
*Kenya FinAccess Wave 4

global KE_Finscope_data 								"FinScope/Raw Data"
global created_data 									"FinScope/Created Data"
global final_data 										"FinScope/Outputs"

************
*KEEP SHG RELEVANT VARIABLES 
************
use "$KE_Finscope_data", clear
keep subregion a2 a4 a5 a6 a7 a81 a82 /* 
*/clustertype age a9 genderofrespondent a14 f1 a15* wealthquint v2* f81 f9 f31 f2* /* relevant demograhpic data
*/ b8 b9* /* ask advice, trust
*/ e* /* SG financial services  
*/ h1* h2* v512 /* SG activities, reasons to belong
*/ v189* /* use chama to invest
*/ l5* l1* /* SGs for business
*/ p3* p6* p7 /* SGs for emergencies
*/ m1* /* finance farm inputs
*/ h4 h6* /* SG training
*/ popwgtnormalized // weights

************************
*RENAME VARIABLES
************************
*DEMOGRAPHICS
**rural
rename clustertype rural_urban
**sex
rename genderofrespondent sex
**phone
rename f1 phone_own 
**id types
rename a151 id_doc //respondents could choose up to three options
rename a152 second_id_doc
rename a153 third_id_doc
**bank account
rename e130 savings_acct
rename v211 check_acct
rename v212 acct_no_checkbook 
**mobile money
rename e137 use_MM
rename f31 MM_provider
rename f241 how_send_money //respondents could choose up to two options
rename f242 second_how_send_money
rename f271 how_receive_money //respondents could choose up to three options
rename f272 second_how_receive_money
rename f273 third_how_receive_money

*INDICATORS
**ask advice
rename b8 advice_source
**financial services
rename e11 save_SACCO
rename e13 save_ASCA
rename v235 save_ROSCA
rename e15 save_friends
rename h1 SG_number
rename e114 loan_SACCO
rename e118 loan_ASCA
rename e119 loan_chama
rename v189 invest_chama
**trust
rename b91 source_most_trust
rename e5 finserv_most_important
rename e5b finserv_why_important
**SHG activities
rename h21 SG_activities
rename v512 second_SG_activities //respondents could choose up to 8 options
rename h23 third_SG_activities
rename h24 fourth_SG_activities
rename h25 fifth_SG_activities
rename h26 sixth_SG_activities
rename h27 seventh_SG_activities
rename h28 eighth_SG_activities
rename h131 SG_bank_acct
rename h132 SG_regcert
rename h133 SG_constitution
rename h134 SG_elect
rename h135 SG_written_record
rename h136 SG_group_checkbook
rename h137 SG_treasurer
rename h138 SG_money_box
rename h139 SG_nomember_manage
rename h1310 SG_borrow_indiv
rename h1311 SG_borrow_mf
rename h1312 SG_borrow_bank
rename h1313 SG_rec_grants
**SG why not
rename h231 why_not_SG //respondents could choose up to 5 options
rename h232 second_why_not_SG
rename h233 third_why_not_SG
rename h234 fourth_why_not_SG
rename h235 fifth_why_not_SG
rename e211 first_close_account //respondents could choose up to 3 options
rename e212 second_close_account 
rename e213 third_close_account 
rename e2231 why_close_SACCO
**main reason belong
rename h17 SG_main_reason
**business services with SHG
rename l51 biz_loan_source //respondents could choose up to 3 options
rename l52 second_biz_loan_source
rename l53 third_biz_loan_source
rename l113 SACCO_business
rename l116 chama_business
rename l12 service_most_important
rename m101 finance_farm_inputs
rename m102 second_finance_farm_inputs
rename m103 third_finance_farm_inputs
**negative experience with SHG
rename h201 negative_exp //respondents could choose up to 8 options
rename h202 second_negative_exp
rename h203 third_negative_exp
rename h204 fourth_negative_exp
rename h205 fifth_negative_exp
rename h206 sixth_negative_exp
rename h207 seventh_negative_exp
rename h208 eighth_negative_exp
rename e161 negative_SACCO //respondents could choose up to 3 options
rename e162 second_negative_SACCO 
rename e163 third_negative_SACCO 
**SHG to deal with a emergency or risk
rename p31 source_borrow_risk //repondents could choose up to 5 options
rename p32 second_borrow_risk 
rename p33 third_borrow_risk 
rename p34 fourth_borrow_risk 
rename p35 fifth_borrow_risk 
rename p61 rural_emergency
rename p62 urban_emergency
rename p7 emergency_source
**SG training
rename h4 SG_training
rename h61 training_provider //respondents could choose up to 4 options
rename h62 second_training_provider
rename h63 third_training_provider
rename h64 fourth_training_provider


************************
*SET WEIGHTS
************************
svyset [pweight=popwgtnormalized]

************************ 
*SEGMENTATION
************************
*rural
gen rural = . 
lab var rural "Respondent lives in a rural location" //Rural = 1, Urban = 0
replace rural = 0 if rural_urban == 2
replace rural = 1 if rural_urban == 1
//n = 8,665

*sex
gen female = .
lab var female "Sex of respondent" //Female = 1, Male = 0
replace female = 1 if sex == 2
replace female = 0 if sex == 1 
//n=8,665

*mobile phone
gen have_phone = .
lab var have_phone "Respondent has access to a mobile phone" //Yes = 1, No = 0 
replace have_phone = 0 if phone_own == 2 & MM_provider == 9
replace have_phone = 1 if phone_own == 1 | MM_provider != 9
//n=8,665

*national ID
gen have_id = .
lab var have_id "Respondent has an ID card" //Yes = 1, No = 0 
replace have_id = 0 if id_doc == 4 
replace have_id = 1 if id_doc == 1 | id_doc == 2 | id_doc == 3 
//n=8,665

*bank account
gen have_bank_acct = .
lab var have_bank_acct "Respondent has access to a bank account" //Yes = 1, No = 0
replace have_bank_acct = 0 if (savings_acct == 2 | savings_acct == 3) & (check_acct == 2 | check_acct == 3) & (acct_no_checkbook == 2 | acct_no_checkbook == 3)
replace have_bank_acct = 1 if savings_acct == 1 | check_acct == 1 | acct_no_checkbook == 1
//n=8,665

*mobile money 
gen have_used_MM = .
lab var have_used_MM "Respondent has used mobile money" //Yes = 1, No = 0
replace have_used_MM = 0 if MM_provider == 9
replace have_used_MM = 1 if MM_provider != 9
replace have_used_MM = 1 if how_send_money == 1 | second_how_send_money == 1 | how_receive_money == 1 | second_how_receive_money == 1 | third_how_receive_money == 1 
//n=8,665

************
*Proportion of individuals who depend on SHG the MOST for financial advice / information 
************
*Individuals who depend on a SACCO the MOST for financial advice / information
gen SACCO_ask_advice_money = .
lab var SACCO_ask_advice_money "Proportion of individuals who have received advice from a SACCO" //Yes=1, No=0
replace SACCO_ask_advice_money = 0 if advice_source != 4 & advice_source != .
replace SACCO_ask_advice_money = 1 if advice_source == 4 //For source: SACCOs = 4
//n=8,665

*Individuals who depend on a chama/ROSCA the MOST for financial advice / information
gen chamaROSCA_ask_advice_money = .
lab var chamaROSCA_ask_advice_money "Proportion of individuals who have received advice from a chama / ROSCA" //Yes=1, No=0
replace chamaROSCA_ask_advice_money = 0 if advice_source != 5 & advice_source != .
replace chamaROSCA_ask_advice_money = 1 if advice_source == 5 // For source: chama / ROSCA = 5
//n=8,665

*Individuals who depend on a SHG the MOST for financial advice / information
gen SHG_ask_advice_money = .
lab var SHG_ask_advice_money "Proportion of individuals who have received advice from a self-help group" //Yes=1, No=0
replace SHG_ask_advice_money = 0 if SACCO_ask_advice_money == 0 | chamaROSCA_ask_advice_money == 0 
replace SHG_ask_advice_money = 1 if SACCO_ask_advice_money == 1 | chamaROSCA_ask_advice_money == 1 
//n=8,665

************
*Proportion of individuals who have used a SHG for financial services 
************
*Individuals who have saved money with a SACCO 
gen SACCO_save = .
lab var SACCO_save "Individuals who have saved with a SACCO" // Yes = 1, No = 0
replace SACCO_save = 0 if save_SACCO == 3 
replace SACCO_save = 1 if save_SACCO == 1 | save_SACCO == 2
//n=8,665

*Individuals who have borrowed money with a SACCO
gen SACCO_borrow = .
lab var SACCO_borrow "Individuals who have borrowed with a SACCO" // Yes = 1, No = 0
replace SACCO_borrow = 0 if loan_SACCO == 3 
replace SACCO_borrow = 1 if loan_SACCO == 1 | loan_SACCO == 2
//n=8,665

*Individuals who have borrowed money with a SACCO as the main source of start-up capital for a self-run business
gen SACCO_biz_loan = .
lab var SACCO_biz_loan "Individuals who have taken a business loan with a SACCO" //Missings coded as 0 because of skip logic
replace SACCO_biz_loan = 0 if biz_loan_source != 3 & second_biz_loan_source != 3 & third_biz_loan_source != 3
replace SACCO_biz_loan = 1 if biz_loan_source == 3 | second_biz_loan_source == 3 | third_biz_loan_source == 3
//n=8,665

*Full count of individuals who have used a SACCO for financial services
gen SACCO_use_finserv = .
lab var SACCO_use_finserv "Individuals who used a SACCO for financial services " //Yes = 1, No = 0
replace SACCO_use_finserv = 0 if SACCO_save == 0 & SACCO_borrow == 0 & SACCO_biz_loan == 0
replace SACCO_use_finserv = 1 if SACCO_save == 1 | SACCO_borrow == 1 | SACCO_biz_loan == 1
//n=8,665

*Individuals who have saved money with an ASCA
gen ASCA_save = .
lab var ASCA_save "Individuals who have saved with an ASCA" // Yes = 1, No = 0
replace ASCA_save = 0 if save_ASCA == 3 
replace ASCA_save = 1 if save_ASCA == 1 | save_ASCA == 2
//n=8,665

*Individuals who have borrowed money with an ASCA
gen ASCA_borrow = .
lab var ASCA_borrow "Individuals who have borrowed with an ASCA" // Yes = 1, No = 0
replace ASCA_borrow = 0 if loan_ASCA == 3 
replace ASCA_borrow = 1 if loan_ASCA == 1 | loan_ASCA == 2
//n=8,665

*Full count of individuals who have used an ASCA for financial services
gen ASCA_use_finserv = .
lab var ASCA_use_finserv "Individuals who used an ASCA for financial services" //Yes = 1, No = 0
replace ASCA_use_finserv = 0 if ASCA_save == 0 & ASCA_borrow == 0
replace ASCA_use_finserv = 1 if ASCA_save == 1 | ASCA_borrow == 1
//n=8,665

*Individuals who have saved money with a chama/ROSCA  
gen chamaROSCA_save = .
lab var chamaROSCA_save "Individuals who have saved money with a chama/ROSCA" //Yes = 1, No = 0
replace chamaROSCA_save = 0 if save_ROSCA == 3 
replace chamaROSCA_save = 1 if save_ROSCA == 1 | save_ROSCA == 2
//n=8,665

*Individuals who have borrowed money with a chama/ROSCA
gen chamaROSCA_borrow = .
lab var chamaROSCA_borrow "Individuals who have borrowed money with a chama/ROSCA" //Yes = 1, No = 0
replace chamaROSCA_borrow = 0 if loan_chama == 3
replace chamaROSCA_borrow = 1 if loan_chama == 1 | loan_chama == 2
//n=8,665

*Individuals who have invested money with a chama/ROSCA
gen chamaROSCA_invest = .
lab var chamaROSCA_invest "Individuals who have invested money with a chama/ROSCA" //Yes = 1, No = 0
replace chamaROSCA_invest = 0 if invest_chama == 3 
replace chamaROSCA_invest = 1 if invest_chama == 1 | invest_chama == 2
//n=8,665

*Full count of individuals who have used a chama/ROSCA for financial services
gen chamaROSCA_use_finserv = .
lab var chamaROSCA_use_finserv "Individuals who have used a chama/ROSCA for financial services" //Yes = 1, No = 0
replace chamaROSCA_use_finserv = 0 if chamaROSCA_save == 0 & chamaROSCA_borrow == 0 & chamaROSCA_invest == 0
replace chamaROSCA_use_finserv = 1 if chamaROSCA_save == 1 | chamaROSCA_borrow == 1 | chamaROSCA_invest == 1
//n=8,665

*Individuals who have taken a loan from a chama as the main source of start-up capital for a self-run business
gen chama_biz_loan = .
lab var chama_biz_loan "Individuals who have taken a business loan with a chama" //Missings coded as 0 because of skip logic
replace chama_biz_loan = 0 if biz_loan_source != 5 & second_biz_loan_source != 5 & third_biz_loan_source != 5
replace chama_biz_loan = 1 if biz_loan_source == 5 | second_biz_loan_source == 5 | third_biz_loan_source == 5
//n=8,665

*Full count of individuals who have used a chama for financial services
gen chama_use_finserv = .
lab var chama_use_finserv "Individuals who have used a chama for financial services"
replace chama_use_finserv = 0 if chama_biz_loan == 0
replace chama_use_finserv = 1 if chama_biz_loan == 1
//n=8,665

*Individuals who have saved with a group of friends
gen group_save = .
lab var group_save "Individuals who have saved money with a group of friends" //Yes = 1, No = 0
replace group_save = 0 if save_friends == 3 
replace group_save = 1 if save_friends == 1 | save_friends == 2
//n=8,665

*Full count of individuals who have saved with a group of friends
gen group_use_finserv = .
lab var group_use_finserv "Individuals who have used a group of friends for financials services"
replace group_use_finserv = 0 if group_save == 0
replace group_use_finserv = 1 if group_save == 1
//n=8,665

*Individuals who have borrowed money from a group to deal with risk
gen unspecified_use_finserv = .
lab var unspecified_use_finserv "Individuals who have borrowed money with a group to deal with risk" //Yes = 1, No = 0
replace unspecified_use_finserv = 0 if (source_borrow_risk != 3 & source_borrow_risk != .) | (second_borrow_risk != 3 & second_borrow_risk != .) | (third_borrow_risk != 3 & third_borrow_risk != .) | /*
*/(fourth_borrow_risk != 3 & fourth_borrow_risk != .) | (fifth_borrow_risk != 3 & fifth_borrow_risk != .)
replace unspecified_use_finserv = 1 if source_borrow_risk == 3 | second_borrow_risk == 3 | third_borrow_risk == 3 | fourth_borrow_risk == 3 | fifth_borrow_risk == 3
//n= 6,875 (the rest of the values up to 8,665 are missing)

*Full count of individuals who have used a SHG for financial services
gen SHG_use_finserv = .
lab var SHG_use_finserv "Individuals who used a self help group for financial services" //Yes = 1, No = 0
replace SHG_use_finserv = 0 if SACCO_use_finserv == 0 | ASCA_use_finserv == 0 | chamaROSCA_use_finserv == 0 | chama_use_finserv == 0 | group_use_finserv == 0 | unspecified_use_finserv == 0
replace SHG_use_finserv = 1 if SACCO_use_finserv == 1 | ASCA_use_finserv == 1 | chamaROSCA_use_finserv == 1 | chama_use_finserv == 1 | group_use_finserv == 1 | unspecified_use_finserv == 1

************
*Proportion of individuals who have interacted with a SHG 
************
*Full count of individuals who have interacted with a SACCO
gen SACCO_use_all = .
lab var SACCO_use_all "Proportion of individuals who interacted with a SACCO in any way" //Yes = 1, No = 0
replace SACCO_use_all = 0 if SACCO_ask_advice_money == 0 & SACCO_use_finserv == 0
replace SACCO_use_all = 1 if SACCO_ask_advice_money == 1 | SACCO_use_finserv == 1
//n=8,665

*Full count of individuals who have interacted with an ASCA
gen ASCA_use_all = .
lab var ASCA_use_all "Proportion of individuals who interacted with an ASCA in any way" //Yes = 1, No = 0
replace ASCA_use_all = 0 if ASCA_save == 0 & ASCA_borrow == 0
replace ASCA_use_all = 1 if ASCA_save == 1 | ASCA_borrow == 1
//n=8,665

*Full count of individuals who have interacted with a chama/ROSCA
gen chamaROSCA_use_all = .
lab var chamaROSCA_use_all "Proportion of individuals who interacted with a chama/ROSCA in any way" //Yes = 1, No = 0
replace chamaROSCA_use_all = 0 if chamaROSCA_ask_advice_money == 0 & chamaROSCA_save == 0 & chamaROSCA_borrow == 0 & chamaROSCA_invest == 0
replace chamaROSCA_use_all = 1 if chamaROSCA_ask_advice_money == 1 | chamaROSCA_save == 1 | chamaROSCA_borrow == 1 | chamaROSCA_invest == 1
//n=8,665

*Full count of individuals who have interacted with a chama
gen chama_use_all = .
lab var chama_use_all "Proportion of individuals who interacted with a chama in any way" //Yes = 1, No = 0
replace chama_use_all = 0 if chama_use_finserv == 0
replace chama_use_all = 1 if chama_use_finserv == 1
//n=8,665

*Full count of individuals who are members of a savings group
gen sg_member = .
lab var sg_member "Proportion of individuals who are members of a savings group" //Yes = 1, No = 0
replace sg_member = 0 if SG_number == 0 
replace sg_member = 1 if SG_number != 0 & SG_number != .
//n=8,665

*Full count of individuals who have interacted with an unspecified group
gen unspecified_use_all = .
lab var unspecified_use_all "Proportion of individuals who interacted with an unspecified group"
replace unspecified_use_all = 0 if unspecified_use_finserv == 0
replace unspecified_use_all = 1 if unspecified_use_finserv == 1
//n=6,875 (rest of the vallues up to 8,665 are missing)

*Full count of individuals who have interacted with a savings group
gen sg_use_all = .
lab var sg_use_all "Proportion of individuals who interacted with a savings group in any way" //Yes = 1, No = 0
replace sg_use_all = 0 if sg_member == 0 
replace sg_use_all = 1 if sg_member == 1
//n=8,665

*Full count of individuals who have interacted with a group of friends
gen groupfriends_use_all = .
lab var groupfriends_use_all "Proportion of individuals who interacted with a group of friends"
replace groupfriends_use_all = 0 if group_use_finserv == 0
replace groupfriends_use_all = 1 if group_use_finserv == 1
//n=8,665

*Full count of individuals who have interacted with a SHG
gen SHG_use_all = .
lab var SHG_use_all "Proportion of individuals who interacted with a SHG in any way" //Yes = 1, No = 0
replace SHG_use_all = 0 if SACCO_use_all == 0 | ASCA_use_all == 0 | chamaROSCA_use_all == 0 | chama_use_all | sg_use_all == 0 | groupfriends_use_all == 0 | unspecified_use_all == 0 
replace SHG_use_all = 1 if SACCO_use_all == 1 | ASCA_use_all == 1 | chamaROSCA_use_all == 1 | chama_use_all | sg_use_all == 1 | groupfriends_use_all == 1 | unspecified_use_all == 1
//n=8,665

gen SHG_no_use = .
lab var SHG_no_use "Proportion of individuals who have not interacted with a SHG"
replace SHG_no_use = 0 if SHG_use_all == 1
replace SHG_no_use = 1 if SHG_use_all == 0
//n=8,665

************
*Proportion of individuals who feel (MOST) confident using a SHG for financial services 
************
*Full count of individuals who feel most confident in a SACCO as a financial provider
gen SACCO_most_conf_finserv = .
lab var SACCO_most_conf_finserv "Proportion of individuals who feel most confident in a SACCO as a financial provider" //Yes = 1, No = 0
replace SACCO_most_conf_finserv = 0 if source_most_trust != 2 & source_most_trust != .
replace SACCO_most_conf_finserv = 1 if source_most_trust == 2
//n=8,665

*Full count of individuals who feel most confident in an ASCA/ROSCA/chama as a financial provider
gen chamaROSCA_most_conf_finserv = .
lab var chamaROSCA_most_conf_finserv "Proportion of individuals who feel most confident in an ASCA/ROSCA/chama as a financial provider" //Yes = 1, No = 0
replace chamaROSCA_most_conf_finserv = 0 if source_most_trust != 11 & source_most_trust != .
replace chamaROSCA_most_conf_finserv = 1 if source_most_trust == 11
//n=8,665

*Full count of individuals who feel MOST confident using a SHG for financial services
gen SHG_most_conf_finserv = .
lab var SHG_most_conf_finserv "Feel MOST confident using a SHG for financial services" //Yes = 1, No = 0
replace SHG_most_conf_finserv = 0 if SACCO_most_conf_finserv == 0 & chamaROSCA_most_conf_finserv == 0
replace SHG_most_conf_finserv = 1 if SACCO_most_conf_finserv == 1 | chamaROSCA_most_conf_finserv == 1
//n=8,665

************
*Counts of SHG activities
************ 
*SG activities 
gen SG_funeral = .
lab var SG_funeral "Proportion of individuals that belong to a SG that contributes towards funerals or other emergencies of members and their families" //missing values are coded as "No" throuhgout because of skip logic on question H1
replace SG_funeral = 0 if SG_activities != 1 | second_SG_activities != 1 | third_SG_activities != 1 | fourth_SG_activities != 1 | fifth_SG_activities != 1 | sixth_SG_activities != 1 | seventh_SG_activities != 1 | /*
*/eighth_SG_activities != 1
replace SG_funeral = 1 if SG_activities == 1 | second_SG_activities == 1 | third_SG_activities == 1 | fourth_SG_activities == 1 | fifth_SG_activities == 1 | sixth_SG_activities == 1 | seventh_SG_activities == 1 | /*
*/eighth_SG_activities == 1
//n=8,665


gen SG_lump_sum = .
lab var SG_lump_sum "Proportion of individuals that belong to a SG that collects money and gives to each member a lump sum (pot) or gift in turn"
replace SG_lump_sum = 0 if SG_activities != 2 | second_SG_activities != 2 | third_SG_activities != 2 | fourth_SG_activities != 2 | fifth_SG_activities != 2 | sixth_SG_activities != 2 | seventh_SG_activities != 2 | /*
*/eighth_SG_activities != 2
replace SG_lump_sum = 1 if SG_activities == 2 | second_SG_activities == 2 | third_SG_activities == 2 | fourth_SG_activities == 2 | fifth_SG_activities == 2 | sixth_SG_activities == 2 | seventh_SG_activities == 2 | /*
*/eighth_SG_activities == 2
//n=8,665

gen SG_lend_interest = .
lab var SG_lend_interest "Proportion of individuals that belong to a SG that saves and lends money to members and non-members to be repaid with interest"
replace SG_lend_interest = 0 if SG_activities != 3 | second_SG_activities != 3 | third_SG_activities != 3 | fourth_SG_activities != 3 | fifth_SG_activities != 3 | sixth_SG_activities != 3 | seventh_SG_activities != 3 | /*
*/eighth_SG_activities != 3
replace SG_lend_interest = 1 if SG_activities == 3 | second_SG_activities == 3 | third_SG_activities == 3 | fourth_SG_activities == 3 | fifth_SG_activities == 3 | sixth_SG_activities == 3 | seventh_SG_activities == 3 | /*
*/eighth_SG_activities == 3
//n=8,665

gen SG_dist_monies = .
lab var SG_dist_monies "Proportion of individuals that belong to a SG that periodically distributes all monies held by the group to its members"
replace SG_dist_monies = 0 if SG_activities != 4 | second_SG_activities != 4 | third_SG_activities != 4 | fourth_SG_activities != 4 | fifth_SG_activities != 4 | sixth_SG_activities != 4 | seventh_SG_activities != 4 | /*
*/eighth_SG_activities != 4
replace SG_dist_monies = 1 if SG_activities == 4 | second_SG_activities == 4 | third_SG_activities == 4 | fourth_SG_activities == 4 | fifth_SG_activities == 4 | sixth_SG_activities == 4 | seventh_SG_activities == 4 | /*
*/eighth_SG_activities == 4
//n=8,665

gen SG_pay_back = .
lab var SG_pay_back "Proportion of individuals that belong to a SG that pays back to members all the savings and interest earned at the end of the cycle"
replace SG_pay_back = 0 if SG_activities != 5 | second_SG_activities != 5 | third_SG_activities != 5 | fourth_SG_activities != 5 | fifth_SG_activities != 5 | sixth_SG_activities != 5 | seventh_SG_activities != 5 | /*
*/eighth_SG_activities != 5
replace SG_pay_back = 1 if SG_activities == 5 | second_SG_activities == 5 | third_SG_activities == 5 | fourth_SG_activities == 5 | fifth_SG_activities == 5 | sixth_SG_activities == 5 | seventh_SG_activities == 5 | /*
*/eighth_SG_activities == 5
//n=8,665

gen SG_save_acct = .
lab var SG_save_acct "Proportion of individuals that belong to a SG that saves together and puts the money in an account"
replace SG_save_acct = 0 if SG_activities != 6 | second_SG_activities != 6 | third_SG_activities != 6 | fourth_SG_activities != 6 | fifth_SG_activities != 6 | sixth_SG_activities != 6 | seventh_SG_activities != 6 | /*
*/eighth_SG_activities != 6
replace SG_save_acct = 1 if SG_activities == 6 | second_SG_activities == 6 | third_SG_activities == 6 | fourth_SG_activities == 6 | fifth_SG_activities == 6 | sixth_SG_activities == 6 | seventh_SG_activities == 6 | /*
*/eighth_SG_activities == 6
//n=8,665

gen SG_investments = .
lab var SG_investments "Proportion of individuals that belong to a SG that makes other kinds of investments as a group e.g. property, business"
replace SG_investments = 0 if SG_activities != 7 | second_SG_activities != 7 | third_SG_activities != 7 | fourth_SG_activities != 7 | fifth_SG_activities != 7 | sixth_SG_activities != 7 | seventh_SG_activities != 7 | /*
*/eighth_SG_activities != 7
replace SG_investments = 1 if SG_activities == 7 | second_SG_activities == 7 | third_SG_activities == 7 | fourth_SG_activities == 7 | fifth_SG_activities == 7 | sixth_SG_activities == 7 | seventh_SG_activities == 7 | /*
*/eighth_SG_activities == 7
//n=8,665

gen SG_stock_market = .
lab var SG_stock_market "Proportion of individuals that belong to a SG that invests in the stock market as a group"
replace SG_stock_market = 0 if SG_activities != 8 | second_SG_activities != 8 | third_SG_activities != 8 | fourth_SG_activities != 8 | fifth_SG_activities != 8 | sixth_SG_activities != 8 | seventh_SG_activities != 8 | /*
*/eighth_SG_activities != 8
replace SG_stock_market = 1 if SG_activities == 8 | second_SG_activities == 8 | third_SG_activities == 8 | fourth_SG_activities == 8 | fifth_SG_activities == 8 | sixth_SG_activities == 8 | seventh_SG_activities == 8 | /*
*/eighth_SG_activities == 8
//n=8,665

************
*Counts of SG why not
************ 
gen notSG_bank_acct = .
lab var notSG_bank_acct "You have an account in a bank or other formal institution" 
replace notSG_bank_acct = 0 if SG_number == 0 & (why_not_SG != 1 & why_not_SG != . | second_why_not_SG != 1 & second_why_not_SG != . | third_why_not_SG != 1 & third_why_not_SG != . | fourth_why_not_SG != 1 & fourth_why_not_SG != . | /*
*/fifth_why_not_SG != 1 & fifth_why_not_SG != .) 
replace notSG_bank_acct = 1 if SG_number == 0 & (why_not_SG == 1 | second_why_not_SG == 1 | third_why_not_SG == 1 | fourth_why_not_SG == 1 | fifth_why_not_SG == 1)
//n=4,921 (the number of people who do not belong to savings groups)

gen notSG_no_money = .
lab var notSG_no_money "You don't have any money"
replace notSG_no_money = 0 if SG_number == 0 & (why_not_SG != 2 & why_not_SG != . | second_why_not_SG != 2 & second_why_not_SG != . | third_why_not_SG != 2 & third_why_not_SG != . | fourth_why_not_SG != 2 & fourth_why_not_SG != . | /*
*/fifth_why_not_SG != 2 & fifth_why_not_SG != .) 
replace notSG_no_money = 1 if SG_number == 0 & (why_not_SG == 2 | second_why_not_SG == 2 | third_why_not_SG == 2 | fourth_why_not_SG == 2 | fifth_why_not_SG == 2)
//n=4,921 (the number of people who do not belong to savings groups)

gen notSG_steal = .
lab var notSG_steal "People steal your money"
replace notSG_steal = 0 if SG_number == 0 & (why_not_SG != 3 & why_not_SG != . | second_why_not_SG != 3 & second_why_not_SG != . | third_why_not_SG != 3 & third_why_not_SG != . | fourth_why_not_SG != 3 & fourth_why_not_SG != . | /*
*/fifth_why_not_SG != 3 & fifth_why_not_SG != .) 
replace notSG_steal = 1 if SG_number == 0 & (why_not_SG == 3 | second_why_not_SG == 3 | third_why_not_SG == 3 | fourth_why_not_SG == 3 | fifth_why_not_SG == 3)
//n=4,921 (the number of people who do not belong to savings groups)

gen notSG_dont_know = .
lab var notSG_dont_know "You don't know about them"
replace notSG_dont_know = 0 if SG_number == 0 & (why_not_SG != 4 & why_not_SG != . | second_why_not_SG != 4 & second_why_not_SG != . | third_why_not_SG != 4 & third_why_not_SG != . | fourth_why_not_SG != 4 & fourth_why_not_SG != . | /*
*/fifth_why_not_SG != 4 & fifth_why_not_SG != .) 
replace notSG_dont_know = 1 if SG_number == 0 & (why_not_SG == 4 | second_why_not_SG == 4 | third_why_not_SG == 4 | fourth_why_not_SG == 4 | fifth_why_not_SG == 4)
//n=4,921 (the number of people who do not belong to savings groups)

gen notSG_no_need = .
lab var notSG_no_need "You don't need any service from them"
replace notSG_no_need = 0 if SG_number == 0 & (why_not_SG != 5 & why_not_SG != . | second_why_not_SG != 5 & second_why_not_SG != . | third_why_not_SG != 5 & third_why_not_SG != . | fourth_why_not_SG != 5 & fourth_why_not_SG != . | /*
*/fifth_why_not_SG != 5 & fifth_why_not_SG != .) 
replace notSG_no_need = 1 if SG_number == 0 & (why_not_SG == 5 | second_why_not_SG == 5 | third_why_not_SG == 5 | fourth_why_not_SG == 5 | fifth_why_not_SG == 5)
//n=4,921 (the number of people who do not belong to savings groups)

gen notSG_dont_trust = .
lab var notSG_dont_trust "You don't trust them"
replace notSG_dont_trust = 0 if SG_number == 0 & (why_not_SG != 6 & why_not_SG != . | second_why_not_SG != 6 & second_why_not_SG != . | third_why_not_SG != 6 & third_why_not_SG != . | fourth_why_not_SG != 6 & fourth_why_not_SG != . | /*
*/fifth_why_not_SG != 6 & fifth_why_not_SG != .) 
replace notSG_dont_trust = 1 if SG_number == 0 & (why_not_SG == 6 | second_why_not_SG == 6 | third_why_not_SG == 6 | fourth_why_not_SG == 6 | fifth_why_not_SG == 6)
//n=4,921 (the number of people who do not belong to savings groups)

gen notSG_time = .
lab var notSG_time "Groups require too much time in meetings"
replace notSG_time = 0 if SG_number == 0 & (why_not_SG != 7 & why_not_SG != . | second_why_not_SG != 7 & second_why_not_SG != . | third_why_not_SG != 7 & third_why_not_SG != . | fourth_why_not_SG != 7 & fourth_why_not_SG != . | /*
*/fifth_why_not_SG != 7 & fifth_why_not_SG != .) 
replace notSG_time = 1 if SG_number == 0 & (why_not_SG == 7 | second_why_not_SG == 7 | third_why_not_SG == 7 | fourth_why_not_SG == 7 | fifth_why_not_SG == 7)
//n=4,921 (the number of people who do not belong to savings groups)

gen notSG_other = .
lab var notSG_other "Other"
replace notSG_other = 0 if SG_number == 0 & (why_not_SG != 8 & why_not_SG != . | second_why_not_SG != 8 & second_why_not_SG != . | third_why_not_SG != 8 & third_why_not_SG != . | fourth_why_not_SG != 8 & fourth_why_not_SG != . | /*
*/fifth_why_not_SG != 8 & fifth_why_not_SG != .) 
replace notSG_other = 1 if SG_number == 0 & (why_not_SG == 8 | second_why_not_SG == 8 | third_why_not_SG == 8 | fourth_why_not_SG == 8 | fifth_why_not_SG == 8)
//n=4,921 (the number of people who do not belong to savings groups)

gen notSG_steal_trust = .
lab var notSG_steal_trust "People steal your money / You don't trust them"
replace notSG_steal_trust = 0 if SG_number == 0 & notSG_steal == 0 & notSG_dont_trust == 0
replace notSG_steal_trust = 1 if SG_number == 0 & (notSG_steal == 1 | notSG_dont_trust == 1)
//n=4,921 (the number of people who do not belong to savings groups)

************
*Counts of main reasons for belonging to a savings group
************
*Proportion of individuals who belong to a SG for each reason
gen SG_sum_turn = .
lab var SG_sum_turn  "Belong to SG to have a lump sum to use when its your turn"
replace SG_sum_turn = 0 if SG_number != 0 & SG_number != . & SG_main_reason != 1  & SG_main_reason != .
replace SG_sum_turn = 1 if SG_number != 0 & SG_number != . & SG_main_reason == 1 
//n= 3,744 (the number of people who belong to savings groups)

gen SG_money_safe = .
lab var SG_money_safe "Belong to SG to keep money safe"
replace SG_money_safe = 0 if SG_number != 0 & SG_number != . & SG_main_reason != 2 & SG_main_reason != .
replace SG_money_safe = 1 if SG_number != 0 & SG_number != . & SG_main_reason == 2
//n= 3,744 (the number of people who belong to savings groups)

gen SG_family_death = .
lab var SG_family_death "Belong to SG to help when there is a death in the family"
replace SG_family_death = 0 if SG_number != 0 & SG_number != . & SG_main_reason != 3 & SG_main_reason != .
replace SG_family_death = 1 if SG_number != 0 & SG_number != . & SG_main_reason == 3
//n= 3,744 (the number of people who belong to savings groups)

gen SG_emergency = .
lab var SG_emergency "Belong to SG to help when there is any other emergency"
replace SG_emergency = 0 if SG_number != 0 & SG_number != . & SG_main_reason != 4 & SG_main_reason != .
replace SG_emergency = 1 if SG_number != 0 & SG_number != . & SG_main_reason == 4
//n= 3,744 (the number of people who belong to savings groups)

gen SG_compulsory = .
lab var SG_compulsory "Belong to SG because it is compulsory in your clan/village"
replace SG_compulsory = 0 if SG_number != 0 & SG_number != . & SG_main_reason != 5 & SG_main_reason != .
replace SG_compulsory = 1 if SG_number != 0 & SG_number != . & SG_main_reason == 5
//n= 3,744 (the number of people who belong to savings groups)

gen SG_socialize = .
lab var SG_socialize "Belong to SG to socialize"
replace SG_socialize = 0 if SG_number != 0 & SG_number != . & SG_main_reason != 6 & SG_main_reason != .
replace SG_socialize = 1 if SG_number != 0 & SG_number != . & SG_main_reason == 6
//n= 3,744 (the number of people who belong to savings groups)

gen SG_exch_ideas = .
lab var SG_exch_ideas "Belong to SG to exchange ideas"
replace SG_exch_ideas = 0 if SG_number != 0 & SG_number != . & SG_main_reason != 7 & SG_main_reason != .
replace SG_exch_ideas = 1 if SG_number != 0 & SG_number != . & SG_main_reason == 7
//n= 3,744 (the number of people who belong to savings groups)

gen SG_invest = .
lab var SG_invest "Belong to SG to invest in bigger things by pulling money / resources together"
replace SG_invest = 0 if SG_number != 0 & SG_number != . & SG_main_reason != 8 & SG_main_reason != .
replace SG_invest = 1 if SG_number != 0 & SG_number != . & SG_main_reason == 8
//n= 3,744 (the number of people who belong to savings groups)

gen SG_buys_goods = .
lab var SG_buys_goods "Belong to SG because the group buys you household goods or farm goods when its your turn"
replace SG_buys_goods = 0 if SG_number != 0 & SG_number != . & SG_main_reason != 9 & SG_main_reason != .
replace SG_buys_goods = 1 if SG_number != 0 & SG_number != . & SG_main_reason == 9
//n= 3,744 (the number of people who belong to savings groups)

gen SG_increase_income = .
lab var SG_increase_income "Belong to SG to increase income by lending"
replace SG_increase_income = 0 if SG_number != 0 & SG_number != . & SG_main_reason != 10 & SG_main_reason != .
replace SG_increase_income = 1 if SG_number != 0 & SG_number != . & SG_main_reason == 10
//n= 3,744 (the number of people who belong to savings groups)

gen SG_only_help = .
lab var SG_only_help "Belong to SG because you could not get money or help anywhere else"
replace SG_only_help = 0 if SG_number != 0 & SG_number != . & SG_main_reason != 11 & SG_main_reason != .
replace SG_only_help = 1 if SG_number != 0 & SG_number != . & SG_main_reason == 11
//n= 3,744 (the number of people who belong to savings groups)

gen SG_easy_money = .
lab var SG_easy_money "Belong to SG because you can get money easily when you need it"
replace SG_easy_money = 0 if SG_number != 0 & SG_number != . & SG_main_reason != 12 & SG_main_reason != .
replace SG_easy_money = 1 if SG_number != 0 & SG_number != . & SG_main_reason == 12
//n= 3,744 (the number of people who belong to savings groups)

gen SG_strength_save = .
lab var SG_strength_save "Belong to SG to get the strength to save from saving with others"
replace SG_strength_save = 0 if SG_number != 0 & SG_number != . & SG_main_reason != 13 & SG_main_reason != .
replace SG_strength_save = 1 if SG_number != 0 & SG_number != . & SG_main_reason == 13
//n= 3,744 (the number of people who belong to savings groups)

gen SG_cant_save_home = .
lab var SG_cant_save_home "Belong to SG because you can't save at home - money gets used on other things"
replace SG_cant_save_home = 0 if SG_number != 0 & SG_number != . & SG_main_reason != 14 & SG_main_reason != .
replace SG_cant_save_home = 1 if SG_number != 0 & SG_number != . & SG_main_reason == 14
//n= 3,744 (the number of people who belong to savings groups)

gen SG_encourage_work = .
lab var SG_encourage_work "Belong to SG because it encourages me to work harder"
replace SG_encourage_work = 0 if SG_number != 0 & SG_number != . & SG_main_reason != 15 & SG_main_reason != .
replace SG_encourage_work = 1 if SG_number != 0 & SG_number != . & SG_main_reason == 15
//n= 3,744 (the number of people who belong to savings groups)

gen SG_other = .
lab var SG_other "Belong to SG for another reason"
replace SG_other = 0 if SG_number != 0 & SG_number != . & SG_main_reason != 16 & SG_main_reason != .
replace SG_other = 1 if SG_number != 0 & SG_number != . & SG_main_reason == 16
//n= 3,744 (the number of people who belong to savings groups)

************
*Proportion of individuals who belong to a SG that has been trained in group management
************
gen SG_train_management = .
lab var SG_train_management "Proportion of individuals who belong to a SG who answered affirmatively that at least one of their groups has been trained in group management" 
replace SG_train_management = 0 if SG_number != 0 & (SG_training == 3 | SG_training == 2)
replace SG_train_management = 1 if SG_number != 0 & SG_training == 1
//n= 3,744 (the number of people who belong to savings groups)

************
*Counts of SG training providers
************
*Proportion of individuals who belong to a SG that has been trained in group management by each provider
gen NGO_church_mosque_provider = .
lab var NGO_church_mosque_provider "Individual belongs to a SG that was trained by an NGO / Church / Mosque"
replace NGO_church_mosque_provider = 0 if (training_provider != 1 & training_provider != .) | (second_training_provider != 1 & second_training_provider != .) | (third_training_provider != 1 & third_training_provider != .) | /*
*/ (fourth_training_provider != 1 & fourth_training_provider != .)
replace NGO_church_mosque_provider = 1 if training_provider == 1 | second_training_provider == 1 | third_training_provider == 1 | fourth_training_provider == 1
//n=1,008 (the number of individuals who belong to a SG that has been trained in group management)

gen private_provider = .
lab var private_provider "Individual belongs to a SG that was trained by a private group trainer"
replace private_provider = 0 if (training_provider != 2 & training_provider != .) | (second_training_provider != 2 & second_training_provider != .) | (third_training_provider != 2 & third_training_provider != .) | /*
*/ (fourth_training_provider != 2 & fourth_training_provider != .)
replace private_provider = 1 if training_provider == 2 | second_training_provider == 2 | third_training_provider == 2 | fourth_training_provider == 2
//n=1,008 (the number of individuals who belong to a SG that has been trained in group management)

gen gov_provider = .
lab var gov_provider "Individual belongs to a SG that was trained by a government body"
replace gov_provider = 0 if (training_provider != 3 & training_provider != .) | (second_training_provider != 3 & second_training_provider != .) | (third_training_provider != 3 & third_training_provider != .) |/*
*/(fourth_training_provider != 3 & fourth_training_provider != .)
replace gov_provider = 1 if training_provider == 3 | second_training_provider == 3 | third_training_provider == 3 | fourth_training_provider == 3
//n=1,008 (the number of individuals who belong to a SG that has been trained in group management)

gen fin_provider = .
lab var fin_provider "Individual belongs to a SG that was trained by a financial provider (MFI)"
replace fin_provider = 0 if (training_provider != 4 & training_provider != .) | (second_training_provider != 4 & second_training_provider != .) | (third_training_provider != 4 & third_training_provider != .) |/*
*/(fourth_training_provider != 4 & fourth_training_provider != .)
replace fin_provider = 1 if training_provider == 4 | second_training_provider == 4 | third_training_provider == 4 | fourth_training_provider == 4
//n=1,008 (the number of individuals who belong to a SG that has been trained in group management)

gen other_provider = .
lab var other_provider "Individual belongs to a SG that was trained by another group"
replace other_provider = 0 if (training_provider != 5 & training_provider != .) | (second_training_provider != 5 & second_training_provider != .) | (third_training_provider != 5 & third_training_provider != .) |/*
*/(fourth_training_provider != 5 & fourth_training_provider != .)
replace other_provider = 1 if training_provider == 5 | second_training_provider == 5 | third_training_provider == 5 | fourth_training_provider == 5
//n=1,008 (the number of individuals who belong to a SG that has been trained in group management)

gen comm_member_provider = .
lab var comm_member_provider "Individual belongs to a SG that was trained by a community member"
replace comm_member_provider = 0 if (training_provider != 6 & training_provider != .) | (second_training_provider != 6 & second_training_provider != .) | (third_training_provider != 6 & third_training_provider != .) |/*
*/(fourth_training_provider != 6 & fourth_training_provider != .)
replace comm_member_provider = 1 if training_provider == 6 | second_training_provider == 6 | third_training_provider == 6 | fourth_training_provider == 6
//n=1,008 (the number of individuals who belong to a SG that has been trained in group management)

gen dont_know_provider = .
lab var dont_know_provider "Individual belongs to a SG that was trained but does not know by whom"
replace dont_know_provider = 0 if (training_provider != 7 & training_provider != .) | (second_training_provider != 7 & second_training_provider != .) | (third_training_provider != 7 & third_training_provider != .) |/*
*/(fourth_training_provider != 7 & fourth_training_provider != .)
replace dont_know_provider = 1 if training_provider == 7 | second_training_provider == 7 | third_training_provider == 7 | fourth_training_provider == 7
//n=1,008 (the number of individuals who belong to a SG that has been trained in group management)

************
*Counts of individuals who anticipate using a SHG as their main source of money in case of emergency
************
gen emergency = 0 if urban_emergency !=. | rural_emergency !=. 
lab var emergency "Proportion of individuals who are able to obtain emergency money within three days"
replace emergency = 1 if urban_emergency == 1
replace emergency = 1 if rural_emergency == 1
//n=8,665

gen ASCArosca_emergency = 0 if emergency==1
lab var ASCArosca_emergency "Proportion of individuals who are able to obtain emergency money within three days who anticipate using an ASCA/ROSCA as their main source"
replace ASCArosca_emergency = 1 if emergency_source == 3
//n=2,981 (number of individuals who are able to obtain emergency money within three days)

gen SACCO_emergency = 0 if emergency==1
lab var SACCO_emergency "Proportion of individuals who are able to obtain emergency money within three days who anticipate using an ASCA/ROSCA as their main source"
replace SACCO_emergency = 1 if emergency_source == 6
//n=2,981 (number of individuals who are able to obtain emergency money within three days)

gen SHG_emergency = .
lab var SHG_emergency "Proportion of individuals who are able to obtain emergency money within three days who anticipate using a SHG as their main source"
replace SHG_emergency = 0 if ASCArosca_emergency == 0 & SACCO_emergency == 0
replace SHG_emergency = 1 if ASCArosca_emergency == 1 | SACCO_emergency == 1
//n=2,981 (number of individuals who are able to obtain emergency money within three days)

************
*Counts of individuals who consider SHG their most important financial instrument
************
gen save_SACCO_most_important = .
lab var save_SACCO_most_important "Proportion of individuals who consider a savings account with a SACCO to be their most important financial instrument" 
replace save_SACCO_most_important = 0 if finserv_most_important != 1 & finserv_most_important != .
replace save_SACCO_most_important = 1 if finserv_most_important == 1
//n=7,444 (the rest are missing values)

gen loan_SACCO_most_important = .
lab var loan_SACCO_most_important "Proportion of individuals who consider a loan from a SACCO to be their most important financial instrument"
replace loan_SACCO_most_important = 0 if finserv_most_important != 14 & finserv_most_important != .
replace loan_SACCO_most_important = 1 if finserv_most_important == 14
//n=7,444 (the rest are missing values)

gen SACCO_most_important = .
lab var SACCO_most_important "Proportion of individuals who consider financial services from a SACCO to be their most important financial instrument"
replace SACCO_most_important = 0 if save_SACCO_most_important == 0 & loan_SACCO_most_important == 0
replace SACCO_most_important = 1 if save_SACCO_most_important == 1 | loan_SACCO_most_important == 1
//n=7,444 (the rest are missing values)

gen save_ASCA_most_important = .
lab var save_ASCA_most_important "Proportion of individuals who consider savings with a ASCA to be their most important financial instrument"
replace save_ASCA_most_important = 0 if finserv_most_important != 3 & finserv_most_important != .
replace save_ASCA_most_important = 1 if finserv_most_important == 3
//n=7,444 (the rest are missing values)

gen loan_ASCA_most_important = .
lab var loan_ASCA_most_important "Proportion of individuals who consider a loan from an ASCA to be their most important financial instrument"
replace loan_ASCA_most_important = 0 if finserv_most_important != 18 & finserv_most_important != .
replace loan_ASCA_most_important = 1 if finserv_most_important == 18
//n=7,444 (the rest are missing values)

gen ASCA_most_important = .
lab var ASCA_most_important "Proportion of individuals who consider financial services from an ASCA to be their most important financial instrument"
replace ASCA_most_important = 0 if save_ASCA_most_important == 0 & loan_ASCA_most_important == 0
replace ASCA_most_important = 1 if save_ASCA_most_important == 1 | loan_ASCA_most_important == 1
//n=7,444 (the rest are missing values)

gen save_chamaROSCA_most_important = .
lab var save_chamaROSCA_most_important "Proportion of individuals who consider savings with a ROSCA to be their most important financial instrument"
replace save_chamaROSCA_most_important = 0 if finserv_most_important != 4 & finserv_most_important != .
replace save_chamaROSCA_most_important = 1 if finserv_most_important == 4
//n=7,444 (the rest are missing values)

gen loan_chamaROSCA_most_important = .
lab var loan_chamaROSCA_most_important "Proportion of individuals who consider a loan from a chama to be their most important financial instrument"
replace loan_chamaROSCA_most_important = 0 if finserv_most_important != 18 & finserv_most_important != .
replace loan_chamaROSCA_most_important = 1 if finserv_most_important == 18
//n=7,444 (the rest are missing values)

gen invest_chamaROSCA_most_important = .
lab var invest_chamaROSCA_most_important "Proportion of individuals who consider group chama investments to be their most important financial instrument"
replace invest_chamaROSCA_most_important = 0 if finserv_most_important != 11 & finserv_most_important != .
replace invest_chamaROSCA_most_important = 1 if finserv_most_important == 11
//n=7,444 (the rest are missing values)

gen chamaROSCA_most_important = .
lab var chamaROSCA_most_important "Proportion of individuals who consider financial services from a chama / ROSCA to be their most important financial instrument"
replace chamaROSCA_most_important = 0 if save_chamaROSCA_most_important == 0 & loan_chamaROSCA_most_important == 0 & invest_chamaROSCA_most_important == 0
replace chamaROSCA_most_important = 1 if save_chamaROSCA_most_important == 1 | loan_chamaROSCA_most_important == 1 | invest_chamaROSCA_most_important == 1
//n=7,444 (the rest are missing values)

gen group_most_important = .
lab var group_most_important "Proportion of individuals who consider savings with a group of friends to be their most important financial instrument"
replace group_most_important = 0 if finserv_most_important != 5 & finserv_most_important != .
replace group_most_important = 1 if finserv_most_important == 5
//n=7,444 (the rest are missing values)

gen SHG_most_important = .
lab var SHG_most_important "Proportion of individuals who consider financial services from a SHG to be their most important financial instrument"
replace SHG_most_important = 0 if SACCO_most_important == 0 & ASCA_most_important == 0 & chamaROSCA_most_important == 0 & group_most_important == 0
replace SHG_most_important = 1 if SACCO_most_important == 1 | ASCA_most_important == 1 | chamaROSCA_most_important == 1 | group_most_important == 1
//n=7,444 (the rest are missing values)

************
*Counts of individuals who have had a negative experience with SHGs
************
gen neg_exp_SACCO_12_mos = .
lab var neg_exp_SACCO_12_mos "Proportion of individuals who have used SACCOs for financial services who have had a negative experience in the past 12 months"
replace neg_exp_SACCO_12_mos = 0 if SACCO_use_finserv == 1 & negative_SACCO == 2 & second_negative_SACCO == 2 & third_negative_SACCO == 2
replace neg_exp_SACCO_12_mos = 1 if SACCO_use_finserv == 1 & (negative_SACCO == 1 | second_negative_SACCO == 1 | third_negative_SACCO == 1)
//n=997 (the rest of the values up to 1,372 which is the n of people who have used SACCOs for financial services, are missing)

gen neg_exp_SG = .  
lab var neg_exp_SG "Proportion of individuals who belong to SG who have had a negative experience" 
replace neg_exp_SG = 0 if SG_number != 0 & negative_exp == 10
replace neg_exp_SG = 1 if SG_number != 0 & negative_exp != . & negative_exp != 10
//n=3,744 (the number of individuals who belong to savings groups)

gen neg_exp_SHG = .
lab var neg_exp_SHG "Proportion of individuals who belong to SGs or have used SACCOs for financial services who have had a negative experience"
replace neg_exp_SHG = 0 if neg_exp_SACCO_12_mos == 0 & neg_exp_SG == 0
replace neg_exp_SHG = 1 if neg_exp_SACCO_12_mos == 1 | neg_exp_SG == 1
//n=1,903 (the rest of the values up to 8,665 are missing at least one value for neg_exp_SACCO or neg_exp_SG)

************
*Counts of individuals who report each negative experience with a SG
************
gen lost_money_outside = .
lab var lost_money_outside "Lost money through theft or fraud by someone outside the group"
replace lost_money_outside = 0 if negative_exp != 1 & negative_exp != . | second_negative_exp != 1 & second_negative_exp != . | third_negative_exp != 1 & third_negative_exp != . | fourth_negative_exp != 1 & fourth_negative_exp != . | /*
*/fifth_negative_exp != 1 & fifth_negative_exp != . | sixth_negative_exp != 1 & sixth_negative_exp != . | seventh_negative_exp != 1 & seventh_negative_exp != . | eighth_negative_exp != 1 & eighth_negative_exp != .
replace lost_money_outside = 1 if negative_exp == 1 | second_negative_exp == 1 | third_negative_exp == 1 | fourth_negative_exp == 1 | fifth_negative_exp == 1 | sixth_negative_exp == 1 | seventh_negative_exp == 1 | /*
*/eighth_negative_exp == 1 
//n= 3,744 (the number of people who belong to a savings group)

gen lost_money_member = .
lab var lost_money_member "Lost money through theft or fraud by a committee member"
replace lost_money_member = 0 if negative_exp != 2 & negative_exp != . | second_negative_exp != 2 & second_negative_exp != . | third_negative_exp != 2 & third_negative_exp != . | fourth_negative_exp != 2 & fourth_negative_exp != . | /*
*/fifth_negative_exp != 2 & fifth_negative_exp != . | sixth_negative_exp != 2 & sixth_negative_exp != . | seventh_negative_exp != 2 & seventh_negative_exp != . | eighth_negative_exp != 2 & eighth_negative_exp != .
replace lost_money_member = 1 if negative_exp == 2 | second_negative_exp == 2 | third_negative_exp == 2 | fourth_negative_exp == 2 | fifth_negative_exp == 2 | sixth_negative_exp == 2 | seventh_negative_exp == 2 | /*
*/eighth_negative_exp == 2
//n= 3,744 (the number of people who belong to a savings group)

gen lost_money_badinv = .
lab var lost_money_badinv "Lost money through a bad investment of funds"
replace lost_money_badinv = 0 if negative_exp != 3 & negative_exp != . | second_negative_exp != 3 & second_negative_exp != . | third_negative_exp != 3 & third_negative_exp != . | fourth_negative_exp != 3 & fourth_negative_exp != . | /*
*/fifth_negative_exp != 3 & fifth_negative_exp != . | sixth_negative_exp != 3 & sixth_negative_exp != . | seventh_negative_exp != 3 & seventh_negative_exp != . | eighth_negative_exp != 3 & eighth_negative_exp != .
replace lost_money_badinv = 1 if negative_exp == 3 | second_negative_exp == 3 | third_negative_exp == 3 | fourth_negative_exp == 3 | fifth_negative_exp == 3 | sixth_negative_exp == 3 | seventh_negative_exp == 3 | /*
*/eighth_negative_exp == 3
//n= 3,744 (the number of people who belong to a savings group)

gen lost_money_dishonesty = .
lab var lost_money_dishonesty "Lost money through dishonesty or default by members"
replace lost_money_dishonesty = 0 if negative_exp != 4 & negative_exp != . | second_negative_exp != 4 & second_negative_exp != . | third_negative_exp != 4 & third_negative_exp != . | fourth_negative_exp != 4 & fourth_negative_exp != . | /*
*/fifth_negative_exp != 4 & fifth_negative_exp != . | sixth_negative_exp != 4 & sixth_negative_exp != . | seventh_negative_exp != 4 & seventh_negative_exp != . | eighth_negative_exp != 4 & eighth_negative_exp != .
replace lost_money_dishonesty = 1 if negative_exp == 4 | second_negative_exp == 4 | third_negative_exp == 4 | fourth_negative_exp == 4 | fifth_negative_exp == 4 | sixth_negative_exp == 4 | seventh_negative_exp == 4 | /*
*/eighth_negative_exp == 4
//n= 3,744 (the number of people who belong to a savings group)

gen loss_membership = .
lab var loss_membership "Loss of membership"
replace loss_membership = 0 if negative_exp != 5 & negative_exp != . | second_negative_exp != 5 & second_negative_exp != . | third_negative_exp != 5 & third_negative_exp != . | fourth_negative_exp != 5 & fourth_negative_exp != . | /*
*/fifth_negative_exp != 5 & fifth_negative_exp != . | sixth_negative_exp != 5 & sixth_negative_exp != . | seventh_negative_exp != 5 & seventh_negative_exp != . | eighth_negative_exp != 5 & eighth_negative_exp != .
replace loss_membership = 1 if negative_exp == 5 | second_negative_exp == 5 | third_negative_exp == 5 | fourth_negative_exp == 5 | fifth_negative_exp == 5 | sixth_negative_exp == 5 | seventh_negative_exp == 5 | /*
*/eighth_negative_exp == 5
//n= 3,744 (the number of people who belong to a savings group)

gen group_conflict = .
lab var group_conflict "Conflict within the group"
replace group_conflict = 0 if negative_exp != 6 & negative_exp != . | second_negative_exp != 6 & second_negative_exp != . | third_negative_exp != 6 & third_negative_exp != . | fourth_negative_exp != 6 & fourth_negative_exp != . | /*
*/fifth_negative_exp != 6 & fifth_negative_exp != . | sixth_negative_exp != 6 & sixth_negative_exp != . | seventh_negative_exp != 6 & seventh_negative_exp != . | eighth_negative_exp != 6 & eighth_negative_exp != .
replace group_conflict = 1 if negative_exp == 6 | second_negative_exp == 6 | third_negative_exp == 6 | fourth_negative_exp == 6 | fifth_negative_exp == 6 | sixth_negative_exp == 6 | seventh_negative_exp == 6 | /*
*/eighth_negative_exp == 6
//n= 3,744 (the number of people who belong to a savings group)

gen poor_leadership = .
lab var poor_leadership "Poor leadership"
replace poor_leadership = 0 if negative_exp != 7 & negative_exp != . | second_negative_exp != 7 & second_negative_exp != . | third_negative_exp != 7 & third_negative_exp != . | fourth_negative_exp != 7 & fourth_negative_exp != . | /*
*/fifth_negative_exp != 7 & fifth_negative_exp != . | sixth_negative_exp != 7 & sixth_negative_exp != . | seventh_negative_exp != 7 & seventh_negative_exp != . | eighth_negative_exp != 7 & eighth_negative_exp != .
replace poor_leadership = 1 if negative_exp == 7 | second_negative_exp == 7 | third_negative_exp == 7 | fourth_negative_exp == 7 | fifth_negative_exp == 7 | sixth_negative_exp == 7 | seventh_negative_exp == 7 | /*
*/eighth_negative_exp == 7
//n= 3,744 (the number of people who belong to a savings group)

gen cash_not_available = .
lab var cash_not_available "Money / cash not available immediately"
replace cash_not_available = 0 if negative_exp != 8 & negative_exp != . | second_negative_exp != 8 & second_negative_exp != . | third_negative_exp != 8 & third_negative_exp != . | fourth_negative_exp != 8 & fourth_negative_exp != . | /*
*/fifth_negative_exp != 8 & fifth_negative_exp != . | sixth_negative_exp != 8 & sixth_negative_exp != . | seventh_negative_exp != 8 & seventh_negative_exp != . | eighth_negative_exp != 8 & eighth_negative_exp != .
replace cash_not_available = 1 if negative_exp == 8 | second_negative_exp == 8 | third_negative_exp == 8 | fourth_negative_exp == 8 | fifth_negative_exp == 8 | sixth_negative_exp == 8 | seventh_negative_exp == 8 | /*
*/eighth_negative_exp == 8
//n= 3,744 (the number of people who belong to a savings group)

gen loan_pressure = .
lab var loan_pressure "Pressured / forced to take a loan"
replace loan_pressure = 0 if negative_exp != 9 & negative_exp != . | second_negative_exp != 9 & second_negative_exp != . | third_negative_exp != 9 & third_negative_exp != . | fourth_negative_exp != 9 & fourth_negative_exp != . | /*
*/fifth_negative_exp != 9 & fifth_negative_exp != . | sixth_negative_exp != 9 & sixth_negative_exp != . | seventh_negative_exp != 9 & seventh_negative_exp != . | eighth_negative_exp != 9 & eighth_negative_exp != .
replace loan_pressure = 1 if negative_exp == 9 | second_negative_exp == 9 | third_negative_exp == 9 | fourth_negative_exp == 9 | fifth_negative_exp == 9 | sixth_negative_exp == 9 | seventh_negative_exp == 8 | /*
*/eighth_negative_exp == 9
//n= 3,744 (the number of people who belong to a savings group)

gen conflict_leadership = .
lab var conflict_leadership "Conflict within the group / Poor leadership"
replace conflict_leadership = 0 if group_conflict == 0 & poor_leadership == 0
replace conflict_leadership = 1 if group_conflict == 1 | poor_leadership == 1
//n= 3,744 (the number of people who belong to a savings group)

gen male = .
replace male = 1 if female == 0
replace male = 0 if female ==1

gen urban = .
replace urban = 1 if rural == 0
replace urban = 0 if rural ==1

gen no_MM_use = .
replace no_MM_use = 1 if have_used_MM == 0
replace no_MM_use = 0 if have_used_MM ==1

gen no_phone_own = .
replace no_phone_own = 1 if have_phone == 0
replace no_phone_own = 0 if have_phone ==1

gen no_official_id = .
replace no_official_id = 1 if have_id == 0
replace no_official_id = 0 if have_id ==1

gen no_bank_own = .
replace no_bank_own = 1 if have_bank_acct == 0
replace no_bank_own = 0 if have_bank_acct ==1

*Saving
save "$created_data/KE_FinScope_final.dta", replace

************
*Disaggregate and Export
************ 
use "$created_data/KE_FinScope_final.dta", clear

*create global of characteristic indicators
global char_indicators  SACCO_most_conf_finserv chamaROSCA_most_conf_finserv SHG_most_conf_finserv  /*
*/ SG_funeral SG_lump_sum SG_lend_interest SG_dist_monies SG_pay_back SG_save_acct SG_investments SG_stock_market /*
*/ notSG_bank_acct notSG_no_money notSG_steal notSG_dont_know notSG_no_need notSG_dont_trust notSG_time notSG_other notSG_steal_trust /*
*/ SG_sum_turn SG_money_safe SG_family_death SG_emergency SG_compulsory SG_socialize SG_exch_ideas SG_invest SG_buys_goods SG_increase_income /* 
*/ SG_only_help SG_easy_money SG_strength_save SG_cant_save_home SG_encourage_work SG_other /*
*/ SG_train_management NGO_church_mosque_provider private_provider gov_provider fin_provider other_provider comm_member_provider dont_know_provider /*
*/ ASCArosca_emergency SACCO_emergency SHG_emergency /*
*/ SACCO_most_important ASCA_most_important chamaROSCA_most_important group_most_important SHG_most_important /*
*/ neg_exp_SACCO_12_mos neg_exp_SG neg_exp_SHG /*
*/ lost_money_outside lost_money_member lost_money_badinv lost_money_dishonesty loss_membership group_conflict poor_leadership cash_not_available loan_pressure conflict_leadership 

*create global of coverage indicators
global coverage_indicators SACCO_ask_advice_money chamaROSCA_ask_advice_money SHG_ask_advice_money /*
*/ SACCO_use_finserv ASCA_use_finserv chamaROSCA_use_finserv unspecified_use_finserv chama_use_finserv group_use_finserv SHG_use_finserv SACCO_use_all ASCA_use_all chamaROSCA_use_all sg_use_all sg_member SHG_use_all /*
*/ chama_use_all unspecified_use_all groupfriends_use_all

*create global of disaggregators
global disaggregation rural female have_used_MM have_phone have_id have_bank_acct 

*create global of users vs. non-user indicators
	*ASCA, Chama, Group of Friends, ROSCA, SACCO, Savings Groups, SHG (unspecified)
	gen ASCA_no_use = .
	replace ASCA_no_use = 1 if ASCA_use_all == 0
	replace ASCA_no_use = 0 if ASCA_use_all == 1
	gen chama_no_use = .
	replace chama_no_use = 1 if chama_use_all == 0
	replace chama_no_use = 0 if chama_use_all == 1
	gen groupfriends_no_use = .
	replace groupfriends_no_use = 1 if groupfriends_use_all == 0
	replace groupfriends_no_use = 0 if groupfriends_use_all == 1
	gen chamaROSCA_no_use = .
	replace chamaROSCA_no_use = 1 if chamaROSCA_use_all == 0
	replace chamaROSCA_no_use = 0 if chamaROSCA_use_all == 1
	gen SACCO_no_use = .
	replace SACCO_no_use = 1 if SACCO_use_all == 0
	replace SACCO_no_use = 0 if SACCO_use_all == 1
	gen sg_no_use = .
	replace sg_no_use = 1 if sg_use_all == 0
	replace sg_no_use = 0 if sg_use_all == 1
	gen unspecified_no_use = .
	replace unspecified_no_use = 1 if unspecified_use_all == 0
	replace unspecified_no_use = 0 if unspecified_use_all == 1
	
global user_nonusers SHG_use_all SHG_no_use SHG_use_finserv ASCA_use_finserv ASCA_use_all ASCA_no_use chama_use_finserv chama_use_all chama_no_use group_use_finserv groupfriends_use_all groupfriends_no_use /*
*/ chamaROSCA_use_finserv chamaROSCA_use_all chamaROSCA_no_use SACCO_use_finserv SACCO_use_all SACCO_no_use sg_use_all sg_no_use unspecified_use_finserv unspecified_use_all unspecified_no_use

*Create global of country demographics
global country_demographics female male rural urban have_used_MM no_MM_use have_phone no_phone_own have_id no_official_id have_bank_acct no_bank_own

*Create global of user/non-user disaggregators
global disagg_user_nonuser female male rural urban have_used_MM no_MM_use have_phone no_phone_own have_id no_official_id have_bank_acct no_bank_own  

*Coverage indicators
putexcel set "$final_data/KE_FinScope_estimates.xls", modify sheet ("Coverage", replace)

svyset [pweight=popwgtnormalized] //We can't specify the correct strata and cluster units here which may affect the SE and CI
local row=2 //Start export into row 2

foreach v of global coverage_indicators {
	quietly svy: mean `v'
	matrix prev_estimates=r(table)'
	matselrc prev_estimates mean_se, c(1 2 5 6) //need to install this package if Stata doesn't recognize this command
	putexcel 	A`row'="FinScope" C`row'="Coverage" I`row'="1.1 All individuals" ///
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
putexcel set "$final_data/KE_FinScope_estimates.xls", modify sheet ("Characteristics", replace)

svyset [pweight=popwgtnormalized] //We can't specify the correct strata and cluster units here which may affect the SE and CI
local row=2 //Start export into row 2

foreach v of global char_indicators {
	quietly svy: mean `v'
	matrix prev_estimates=r(table)'
	matselrc prev_estimates mean_se, c(1 2 5 6) //need to install this package if Stata doesn't recognize this command
	putexcel 	A`row'="FinScope" C`row'="Characteristics" I`row'="1.1 All individuals" ///
				L`row'="`v'" M`row'=matrix(mean_se) Q`row'=(e(N))
	local ++row
}	
		
foreach v of global char_indicators {		
	foreach x of global disaggregation {		
		forvalues i = 0/1 {
			quietly svy, subpop(if `x'==`i'): mean `v'
			matrix prev_estimates=r(table)'
			matselrc prev_estimates mean_se, c(1 2 5 6)
			putexcel 	A`row'="FinScope" C`row'="Characteristics" I`row'="`x'=`i'" ///
						L`row'="`v'" M`row'=matrix(mean_se) Q`row'=(e(N_sub))
			local ++row
		}
	}	
}



*Users vs. Non-Users Disaggregation
putexcel set "$final_data\KE_FinScope_estimates.xls", modify sheet("Users vs. Non-Users", replace)

svyset [pweight=popwgtnormalized] //We can't specify the correct strata and cluster units here which may affect the SE and CI
local row=2 //Start export into row 2

foreach v of global disagg_user_nonuser {		
	foreach x of global user_nonusers {		
			quietly svy, subpop(if `x'==1): mean `v'
			matrix prev_estimates=r(table)'
			matselrc prev_estimates mean_se, c(1 2 5 6)
			putexcel 	A`row'="Kenya" C`row'="FinScope" E`row'="Proportion of individuals who exhibit each characteristic" ///
						F`row'="`x'" H`row'="`v'=1" I`row'=matrix(mean_se) M`row'=(e(N_sub))
			local ++row
	}	
}



*Country Demographics indicators
putexcel set "$final_data\KE_FinScope_estimates.xls", modify sheet("Country Demographics", replace)

svyset [pweight=popwgtnormalized] //We can't specify the correct strata and cluster units here which may affect the SE and CI
local row=2 //Start export into row 2	
		
foreach x of global country_demographics {		
			quietly svy: mean `x'
			matrix prev_estimates=r(table)'
			matselrc prev_estimates mean_se, c(1 2 5 6)
			putexcel 	A`row'="FinScope" C`row'="Demographics" I`row'="`x'=`1'" ///
						L`row'="`v'" M`row'=matrix(mean_se) Q`row'=(e(N))
			local ++row

}

