
/*---------------------------------------------------------------------------------------------------------------------------------------------------
*Title/Purpose 	: This do.file was developed by the Evans School Policy Analysis & Research Group (EPAR) 
				  for the construction of indicators related to Coverage and Characteristics of Self-Help Groups using the
				  Uganda FinScope survey Wave 3 (2013) 												
*Author(s)		: Pierre Biscaye, Kirby Callaway, Elan Ebeling, Annie Rose Favreau, Mel Howlett, 
				  Daniel Lunchik-Seymour, Emily Morton, Kels Phelps,
				  C. Leigh Anderson & Travis Reynolds

				*Acknowledgments: We acknowledge the helpful contributions of members of the Bill & Melinda Gates Foundation Gender Equality team in 
				discussing indicator construction decisions. All coding errors remain ours alone.
				
*Date			: 13 July 2018
----------------------------------------------------------------------------------------------------------------------------------------------------*/

*Data source
*-----------
*The Uganda FinScope household survey was collected by the Economic Policy Research Centre (EPRC)
*and the Financial Sector Deepening Trust Uganda (FSD Uganda)
*over the period June - July 2013.
*All the raw data, questionnaires, and basic information documents are available upon request from the
*Financial Sector Deepening Trust Uganda website: http://fsduganda.or.ug/

*Summary of executing the Master do.file
*-----------
*This master do file constructs selected indicators using the Kenya FinAccess data set.
*Using a data file from within the "Raw Data" folder within the "FinScope" folder, 
*the do-file constructs relevant indicators related to Self-Help Group coverage
*and Use and saves final dta files with all created variables and indicators
*in the "Created Data" folder within the "FII" folder.
*Additionally, the do-file creates Excel spreadsheet with estimates of coverage 
*and characteristic indicators disaggregated by gender, mobile phone access,
*bank account access, urban vs. rural, possession of official identification,
*poverty level, and mobile money use.
*These estimates are saved in the "Outputs" folder with in the "FII" folder.

*Throughought the do-file we refer to "Self-Help Groups" as "SHGs".

clear
set more off

//Set directories
*These paths correspond to the folders where the raw data files are located and where the created data and final data will be stored.
global UG_Finscope_data 								"FinScope/Raw Data"
global created_data 									"FinScope/Created Data"
global final_data 										"FinScope/Outputs"

************
*KEEP SHG RELEVANT VARIABLES 
************
use "$UG_Finscope_data/finscope13_1.dta", clear

keep q2a q2b q3a q3b q4a q4b q5a q5b q6a q6b eprc_id urban /* 
*/ pn8 pn7a p2a p4a nk3_* k1* /*relevant demographic data
*/ n81_xi /* ask advice
*/ b2* nb3* /* save $ in past 12 months
*/ c3 c4 c6* c9* /* borrow $ in past 12 months
*/ d1_* nl* g1* g5* g8* ng1* ng2* ng3* ng4* /* MM and remittances
*/ d12* /* bank account
*/ d2* c10* n84* c22* /* general SHGs
*/ nc29_d n1_1_i n1_2 n84* /* SACCO
*/ nc29_f /* VSLA
*/ b10_1  //investment account 

************************
*RENAME VARIABLES
************************
*DEMOGRAPHICS
**sex
rename PN7a sex //Male=1 ; Female=2
**poverty
	//MISSING PPI
**phone
*nk3_1  //Yes=1 ; No=2
gen phone_access = .
replace phone_access = 1 if nk3_1 == 1
replace phone_access = 0 if nk3_1 == 2
*k1_1  //Yes=1 ; No=2
gen phone_own = . 
replace phone_own = 1 if k1_1 == 1
replace phone_own = 0 if k1_1 == 2
**id types	//no ID question 
**bank account
*has an investment account at a financial institution
rename b10_1 investment_account //Yes=1 ; No=0
*has a borrowing account
gen bank_borrow = 0
replace bank_borrow = 1 if C9a_1==1 | C9b_1==1 | C9c_1==1 | C9a_2==1 | C9b_2==1 | C9c_2==1 | C9a_3==1 | /*
*/ C9b_3==1 | C9c_3==1 | C9a_4==1 | C9b_4==1 | C9c_4==1 | C9a_5==1 | C9b_5==1 | C9c_5==1 
*saves with a bank
rename nb3_b bank_save  //Yes=1 ; No=0
*has a savings account
gen bank_product_savings = 0 if d1_1 != .
replace bank_product_savings=1 if D2a_1==1 | D2b_1==1 | D2c_1==1
gen bank_product_fixeddep = 0 if d1_2 != .
replace bank_product_fixeddep=1 if D2a_2==1 | D2b_2==1 | D2c_2==1
gen bank_product_joint = 0 if d1_3 != .
replace bank_product_joint=1 if D2a_3==1 | D2b_3==1 | D2c_3==1
gen bank_product_current = 0 if d1_4 != .
replace bank_product_current=1 if D2a_4==1 | D2b_4==1 | D2c_4==1
gen bank_product_ATM = 0 if d1_5 != .
replace bank_product_ATM=1 if D2a_5==1 | D2b_5==1 | D2c_5==1
gen bank_product_creditcard = 0 if d1_6 != .
replace bank_product_creditcard=1 if D2a_6==1 | D2b_6==1 | D2c_6==1
gen bank_product_investment = 0 if d1_7 != .
replace bank_product_investment=1 if D2a_7==1 | D2b_7==1 | D2c_7==1
gen bank_product_pers_loan = 0 if d1_8 != .
replace bank_product_pers_loan=1 if D2a_8==1 | D2b_8==1 | D2c_8==1
gen bank_product_overdraft = 0 if d1_9 != .
replace bank_product_overdraft=1 if D2a_9==1 | D2b_9==1 | D2c_9==1
gen bank_product_mortgage = 0 if d1_10 != .
replace bank_product_mortgage=1 if D2a_10==1 | D2b_10==1 | D2c_11==1
gen bank_product_homeimprove = 0 if d1_11 != .
replace bank_product_homeimprove=1 if D2a_11==1 | D2b_11==1 | D2c_11==1
gen bank_product_commercial = 0 if d1_12 != .
replace bank_product_commercial=1 if D2a_12==1 | D2b_12==1 | D2c_12==1
gen bank_product_transfer = 0 if d1_13 != .
replace bank_product_transfer=1 if D2a_13==1 | D2b_13==1 | D2c_13==1
gen bank_product_mobilebank = 0 if d1_14 != .
replace bank_product_mobilebank=1 if D2a_14==1 | D2b_14==1 | D2c_14==1
gen bank_product_cellbank = 0 if d1_15 != .
replace bank_product_cellbank=1 if D2a_15==1 | D2b_15==1 | D2c_15==1
gen bank_product_onlinebank = 0 if d1_16 != .
replace bank_product_onlinebank=1 if D2a_16==1 | D2b_16==1 | D2c_16==1
gen bank_product_other = 0 if d1_17 != .
replace bank_product_other=1 if D2a_17==1 | D2b_17==1 | D2c_17==1
	
gen use_bank = .	 
global products bank_product_*

foreach x of varlist $products {
	replace use_bank = 0 if `x' != . 
	}
	
foreach x of varlist $products { 
	replace use_bank = 1 if `x' == 1 
	}

*joint account		//Any question about sole ownership is missing
gen joint_acct = d1_3 //Yes=1 ; No=0
*use another person's account
rename d12_c useotherperson_acct  //Yes=1 ; No=0

**mobile money
rename nl2 registered_MM //Yes=1 ; No=2
rename nl3 useotherperson_MM //Yes=1 ; No=2

*INDICATORS
**ask advice
rename N81_xi ask_advice_finance  //Yes=1 ; No=2
**financial services
gen if_save = .
replace if_save = 0 if b2_a==0 | b2_b==0 | b2_c==0 | b2_d==0
replace if_save = 1 if b2_a==1 | b2_b==1 | b2_c==1 | b2_d==1
rename nb3_d SACCO_save
rename nb3_f VSLA_save
rename nb3_g ROSCA_save

gen if_borrow = .
replace if_borrow = 0 if c3==2
replace if_borrow = 1 if c3==1 

gen current_loan = . 
gen former_loan = . 

forvalues i = 1/12 { 
	replace current_loan = 0 if c6_`i' != . 
	replace former_loan = 0 if c6_`i' != . 
	}
	
forvalues i = 1/12 { 
	replace current_loan = 1 if c6_`i' == 1 
	replace former_loan = 1 if c6_`i' == 2
	}

gen SACCO_current_loan = 0 if current_loan != . //SACCOs
gen ASCA_current_loan = 0 if current_loan != . //ASCAs
gen VSLA_current_loan = 0 if current_loan != . //VSLAs
gen SG_current_loan = 0 if current_loan != . //Savings Groups/Clubs
gen ROSCA_current_loan = 0 if current_loan != . //RoSCAs
gen IC_current_loan = 0 if current_loan != . //Investment Clubs
gen burial_current_loan = 0 if current_loan != . //Burial societies

	
forvalues i = 1/11 { 
	replace SACCO_current_loan = 1 if C9a_`i' == 4 | C9b_`i' == 4 | C9c_`i' == 4 
	replace ASCA_current_loan = 1 if C9a_`i' == 6 | C9b_`i' == 6 | C9c_`i' == 6 
	replace VSLA_current_loan = 1 if C9a_`i' == 8 | C9b_`i' == 8 | C9c_`i' == 8 
	replace SG_current_loan = 1 if C9a_`i' == 9 | C9b_`i' == 9 | C9c_`i' == 9 
	replace ROSCA_current_loan = 1 if C9a_`i' == 10 | C9b_`i' == 10 | C9c_`i' == 10 
	replace IC_current_loan = 1 if C9a_`i' == 12 | C9b_`i' == 12 | C9c_`i' == 12 
	replace burial_current_loan = 1 if C9a_`i' == 13 | C9b_`i' == 13 | C9c_`i' == 13 
}


**confidence/trust in financial institution
gen bank_trust = N84_iii_A
gen SACCO_trust = N84_iii_D
gen VSLA_trust = N84_iii_F

*SHG ACTIVITIES		//missing SHG activities
**why no SHG		//missing a question about why an individual does not belong to a SHG
**main reason belonging to SHG		//missing main reason for belonging to SHG
**is it easier to borrow now that in 2009 - ONLY those who are currently borrowing with service in question
gen SACCO_easy_borrow = .
replace SACCO_easy_borrow = 0 if c10_4==2 | c10_4==3
replace SACCO_easy_borrow = 1 if c10_4==1

gen ASCA_easy_borrow = .
replace ASCA_easy_borrow = 0 if c10_6==2 | c10_6==3
replace ASCA_easy_borrow = 1 if c10_6==1

gen VSLA_easy_borrow = .
replace VSLA_easy_borrow = 0 if c10_8==2 | c10_8==3
replace VSLA_easy_borrow = 1 if c10_8==1

gen SG_easy_borrow = .
replace SG_easy_borrow = 0 if c10_9==2 | c10_9==3
replace SG_easy_borrow = 1 if c10_9==1

gen ROSCA_easy_borrow = .
replace ROSCA_easy_borrow = 0 if c10_10==2 | c10_10==3
replace ROSCA_easy_borrow = 1 if c10_10==1

gen investclub_easy_borrow = .
replace investclub_easy_borrow = 0 if c10_11==2 | c10_11==3
replace investclub_easy_borrow = 1 if c10_11==1

gen burial_easy_borrow = . 
replace burial_easy_borrow = 0 if c10_13==2 | c10_13==3
replace burial_easy_borrow = 1 if c10_13==1

**form of security needed for load
	//only for VSLA and SACCO
	//Land title=1 ; household assets=2 ; livestock=3 ; car/motorcycle=4 ; machinery/tools=5 ; shares=6 ; insurance=7 ; other=8
rename C22_iv SACCO_req_security 
rename C22_v VSLA_req_security 

**sources of financial information
	//only for SACCO
gen SACCO_info_source = n1_1_i  //Yes=1 ; No=0 (confirm in codebook)
gen SACCO_main_info_source = 0 if SACCO_info_source !=.
replace SACCO_main_info_source=1 if n1_2==09
**financial institutions used for each product
	//only for SACCO
gen SACCO_product_savings = 0 if d1_1 != . 
replace SACCO_product_savings=1 if D2a_1==5 | D2b_1==5 | D2c_1==5
gen SACCO_product_fixeddep = 0 if d1_2 != . 
replace SACCO_product_fixeddep=1 if D2a_2==5 | D2b_2==5 | D2c_2==5
gen SACCO_product_joint = 0 if d1_3 != . 
replace SACCO_product_joint=1 if D2a_3==5 | D2b_3==5 | D2c_3==5
gen SACCO_product_current = 0 if d1_4 != . 
replace SACCO_product_current=1 if D2a_4==5 | D2b_4==5 | D2c_4==5
gen SACCO_product_ATM = 0 if d1_5 != . 
replace SACCO_product_ATM=1 if D2a_5==5 | D2b_5==5 | D2c_5==5
gen SACCO_product_creditcard = 0 if d1_6 != . 
replace SACCO_product_creditcard=1 if D2a_6==5 | D2b_6==5 | D2c_6==5
gen SACCO_product_investment = 0 if d1_7 != . 
replace SACCO_product_investment=1 if D2a_7==5 | D2b_7==5 | D2c_7==5
gen SACCO_product_pers_loan = 0 if d1_8 != . 
replace SACCO_product_pers_loan=1 if D2a_8==5 | D2b_8==5 | D2c_8==5
gen SACCO_product_overdraft = 0 if d1_9 != . 
replace SACCO_product_overdraft=1 if D2a_9==5 | D2b_9==5 | D2c_9==5
gen SACCO_product_mortgage = 0 if d1_10 != . 
replace SACCO_product_mortgage=1 if D2a_10==5 | D2b_10==5 | D2c_11==5
gen SACCO_product_homeimprove = 0 if d1_11 != . 
replace SACCO_product_homeimprove=1 if D2a_11==5 | D2b_11==5 | D2c_11==5
gen SACCO_product_commercial = 0 if d1_12 != . 
replace SACCO_product_commercial=1 if D2a_12==5 | D2b_12==5 | D2c_12==5
gen SACCO_product_transfer = 0 if d1_13 != . 
replace SACCO_product_transfer=1 if D2a_13==5 | D2b_13==5 | D2c_13==5
gen SACCO_product_mobilebank = 0 if d1_14 != . 
replace SACCO_product_mobilebank=1 if D2a_14==5 | D2b_14==5 | D2c_14==5
gen SACCO_product_cellbank = 0 if d1_15 != . 
replace SACCO_product_cellbank=1 if D2a_15==5 | D2b_15==5 | D2c_15==5
gen SACCO_product_onlinebank = 0 if d1_16 != . 
replace SACCO_product_onlinebank=1 if D2a_16==5 | D2b_16==5 | D2c_16==5
gen SACCO_product_other = 0 if d1_17 != . 
replace SACCO_product_other=1 if D2a_17==5 | D2b_17==5 | D2c_17==5

**opinion of lending behavior for SACCO
gen SACCO_op_highinterest = N84_i_D
gen SACCO_op_shortgrace = N84_ii_D
gen SACCO_op_badrepaysched = N84_iv_D
gen SACCO_op_highcollateral = N84_v_D
gen SACCO_op_highdocument = N84_vi_D
gen SACCO_op_unsafeloc = N84_vii_D
gen SACCO_op_poorcustomerc = N84_viii_D
gen SACCO_op_poorcontract = N84_ix_D
gen SACCO_op_unofficialcharge = N84_x_D
gen SACCO_op_toomuchtime = N84_xi_D


**opinion of lending behavior for VSLA
gen VSLA_op_highinterest = N84_i_F
gen VSLA_op_shortgrace = N84_ii_F
gen VSLA_op_badrepaysched = N84_iv_F
gen VSLA_op_highcollateral = N84_v_F
gen VSLA_op_highdocument = N84_vi_F
gen VSLA_op_unsafeloc = N84_vii_F
gen VSLA_op_poorcustomerc = N84_viii_F
gen VSLA_op_poorcontract = N84_ix_F
gen VSLA_op_unofficialcharge = N84_x_F
gen VSLA_op_toomuchtime = N84_xi_F
	//no opinion for other SHGs

************************
*SET WEIGHTS
************************
svyset [pweight=pidmult]  

************************ 
*SEGMENTATION
************************
*rural
gen rural = .
lab var rural "Respondent lives in a rural location" //Rural = 1, Urban = 0
replace rural = 1 if urban == 0 
replace rural = 0 if urban == 1

*sex
gen female = .
lab var female "Sex of respondent" //Female = 1, Male = 0
replace female = 1 if sex == 2
replace female = 0 if sex == 1 

*poverty		//missing poverty indicators

*mobile phone
gen have_phone = .
lab var have_phone "Respondent has access to a mobile phone" //Yes = 1, No = 0 
replace have_phone = 0 if phone_access == 0 | phone_own == 0
replace have_phone = 1 if phone_access == 1 | phone_own == 1

*bank account
gen have_bank_acct = use_bank
lab var have_bank_acct "Respondent has access to a bank account" //Yes = 1, No = 0

*mobile money 
gen have_used_MM = 0 if nl1 != . 
lab var have_used_MM "Respondent has used mobile money" //Yes = 1, No = 0
replace have_used_MM = 1 if registered_MM == 1 | useotherperson_MM == 1	
replace have_used_MM = 1 if g5_c /*"Sent MM"*/ == 1 | ng3_c /*"Receive MM"*/ == 1 

************
*Proportion of individuals who have received advice about money matters 		//missing in Uganda
************

************
*Proportion of individuals who have used a SHG for financial services 
************
	
*Individuals who are saving with a SACCO
lab var SACCO_save "Individuals who save with a SACCO"
//N=3,118

*Individuals who currently borrow with a SACCO
lab var SACCO_current_loan "Individuals who currently borrow with a SACCO"
//N=3,383

*Individuals who currently use a financial product from a SACCO
gen SACCO_use_finproduct = .
lab var SACCO_use_finproduct "Individuals who use a financial product from a SACCO"

global SACCO_use SACCO_product_*

foreach x of varlist $SACCO_use { 
	replace SACCO_use_finproduct = 0 if `x' != .
	} 
	
foreach x of varlist $SACCO_use { 
	replace SACCO_use_finproduct = 1 if `x' == 1
	}
//N=3,307
	
*Full count of individuals who have used a SACCO for financial services
gen SACCO_use_finserv = .
lab var SACCO_use_finserv "Individuals who use a SACCO for financial services " //Yes = 1, No = 0
replace SACCO_use_finserv = 0 if SACCO_save == 0 | SACCO_current_loan == 0 | SACCO_use_finproduct == 0 //Any respondent who had an observation for at least one of these variables
replace SACCO_use_finserv = 1 if SACCO_save == 1 | SACCO_current_loan == 1 | SACCO_use_finproduct == 1
//N=3,394

*Individuals who are saving with a VSLA
lab var VSLA_save "Individuals who save with a VSLA"
//N=3,118

*Individuals who currently borrow with a VSLA
lab var VSLA_current_loan "Individuals who currently borrow with a VSLA"
//N=3,383

*Full count of individuals who have used a VSLA for financial services
gen VSLA_use_finserv = .
lab var VSLA_use_finserv "Individuals who use a VSLA for financial services " //Yes = 1, No = 0
replace VSLA_use_finserv = 0 if VSLA_save == 0 | VSLA_current_loan == 0 
replace VSLA_use_finserv = 1 if VSLA_save == 1 | VSLA_current_loan == 1
//N=3,393

*Individuals who are saving with a ROSCA
lab var ROSCA_save "Individuals who save with a ROSCA"
//N=3,118

*Individuals who currently borrow with a ROSCA
lab var ROSCA_current_loan "Individuals who currently borrow with a ROSCA"
//N=3,383

*Full count of individuals who have used a ROSCA for financial services
gen ROSCA_use_finserv = .
lab var ROSCA_use_finserv "Individuals who use a ROSCA for financial services " //Yes = 1, No = 0
replace ROSCA_use_finserv = 0 if ROSCA_save == 0 | ROSCA_current_loan == 0 
replace ROSCA_use_finserv = 1 if ROSCA_save == 1 | ROSCA_current_loan == 1
//N=3,393

*Individuals who currently borrow with a savings group
lab var SG_current_loan "Individuals who currently borrow with a savings group"
//N=3,383

*Individuals who currently borrow with a ASCA
lab var ASCA_current_loan "Individuals who currently borrow with a ASCA"
//N=3,383
	
lab var IC_current_loan "Individuals who currently borrow with an Investment Club" 
//N=3,383

lab var burial_current_loan	"Individuals who currently borrow with a Burial society"
//N=3,383
	
	*Individuals who are saving with an SHG
gen SHG_save = .
la var SHG_save "Individuals who save with an SHG" 
replace SHG_save = 0 if SACCO_save==0 | VSLA_save==0 | ROSCA_save==0
replace SHG_save = 1 if SACCO_save==1 | VSLA_save==1 | ROSCA_save==1
//N=3,118

*Individuals who currently borrow with an SHG
gen SHG_borrow = .
la var SHG_borrow "Individuals who currently borrow with an SHG" 
replace SHG_borrow = 0 if SACCO_current_loan==0 | VSLA_current_loan==0 | ROSCA_current_loan==0 | SG_current_loan==0 | ASCA_current_loan==0
replace SHG_borrow = 1 if SACCO_current_loan==1 | VSLA_current_loan==1 | ROSCA_current_loan==1 | SG_current_loan==1 | ASCA_current_loan==1
//N=3,383

*Full count of individuals who have used a SHG for financial services
gen SHG_use_finserv = .
lab var SHG_use_finserv "Individuals who used a self help group for financial services " //Yes = 1, No = 0
replace SHG_use_finserv = 0 if SACCO_use_finserv == 0 | VSLA_use_finserv == 0 | ROSCA_use_finserv == 0 | SHG_save == 0 | SHG_borrow == 0
replace SHG_use_finserv = 1 if SACCO_use_finserv == 1 | VSLA_use_finserv == 1 |  ROSCA_use_finserv == 1 | SHG_save == 1 | SHG_borrow == 1
//N=3,394

*Individuals report that SACCOs are a source of information regarding financial matters
la var SACCO_info_source "Individuals who reported SACCOs are a source of financial info"
//N=3,361

*Individuals report that SACCOs are the main source of financial information
la var SACCO_main_info_source "Individuals who reported SACCOs are the main source of financial info"
//N=3,361

*Individuals report that they are a member of an informal insurance group like a Burial Society
gen burial_member = f11 
la var burial_member "Individuals who reported being members of an informal insurance group like a burial society" 
//N=3,357

*Individuals who have interacted with a SACCO in any way
gen SACCO_use_any = . 
la var SACCO_use_any "Individuals who have interacted with a SACCO in any way" 
replace SACCO_use_any = 0 if SACCO_use_finserv == 0 | SACCO_info_source == 0 
replace SACCO_use_any = 1 if SACCO_use_finserv == 1 | SACCO_info_source == 1
//N=3,394

*Individuals who have interacted with a Burial Society in any way 
gen burial_use_any = . 
la var burial_use_any "Individuals who have interacted with a Burial Society in any way"
replace burial_use_any = 0 if burial_current_loan == 0 | burial_member == 0 
replace burial_use_any = 1 if burial_current_loan == 1 | burial_member == 1
//N=3,388

*Individuals who have interacted with an SHG in any way 
	*DJLS: this includes using SHGs for financial services, for a source of financial information, or joining as a member 
gen SHG_use_any = . 
la var SHG_use_any "Individuals who have interacted with a SHG in any way" 
replace SHG_use_any = 0 if SHG_use_finserv == 0 | SACCO_info_source == 0 | burial_member == 0 
replace SHG_use_any = 1 if SHG_use_finserv == 1 | SACCO_info_source == 1 | burial_member == 1 
//N=3,394

************
*Individiuals' opinions concerning the lending behavior of SHGs 
************
*Individals who trust the lending behavior of banks
lab var bank_trust "Individuals who trust bank lending behavior"
//N=3,401

*Individals who trust the lending behavior of SACCOs
lab var SACCO_trust "Individuals who trust SACCO lending behavior"
//N=3,401

*Individals who think SACCO lending has too high of an interest rate
lab var SACCO_op_highinterest "Individuals who think the SACCO interest rate is too high"
//N=3,401

*Individals who think the SACCO grace period is short to start repaying the loan
lab var SACCO_op_shortgrace "Individuals who think the SACCO grace period is too short"
//N=3,401

*Individals who think the SACCO repayment schedule is inconvenient
lab var SACCO_op_badrepaysched "Individuals who think the SACCO repayment schedule is inconvenient"
//N=3,401

*Individals who think the SACCO collateral security is unaffordable
lab var SACCO_op_highcollateral "Individuals who think the SACCO collateral security is unaffordable"
//N=3,401

*Individals who think SACCOs require a lot of pre-loan documentation
lab var SACCO_op_highdocument "Individuals who think SACCOs require a lot of documentation"
//N=3,401

*Individals who think SACCOs provide services in unsafe locations
lab var SACCO_op_unsafeloc "Individuals who think SACCOs provide services in unsafe locations"
//N=3,401

*Individals who think SACCOs have poor customer care
lab var SACCO_op_poorcustomerc "Individuals who think SACCOs have poor customer care"
//N=3,401

*Individals who don't understand SACCO contracts
lab var SACCO_op_poorcontract "Individuals who don't understand SACCO contracts"
//N=3,401

*Individals who were asked by SACCO staff to pay unofficial charges
lab var SACCO_op_unofficialcharge "Individuals who were asked by SACCO to pay unofficial charges"
//N=3,401

*Individals who think getting a SACCO loan takes a lot of time
lab var SACCO_op_toomuchtime "Individuals who think getting a SACCO loan takes a lot of time"
//N=3,401

*Individals who trust the lending behavior of VSLAs
lab var VSLA_trust "Individuals who trust VSLA lending behavior"
//N=3,401

*Individals who think VSLAs lending has too high of an interest rate
lab var VSLA_op_highinterest "Individuals who think the VSLA interest rate is too high"
//N=3,401

*Individals who think the VSLA grace period is short to start repaying the loan
lab var VSLA_op_shortgrace "Individuals who think the VSLA grace period is too short"
//N=3,401

*Individals who think the VSLA repayment schedule is inconvenient
lab var VSLA_op_badrepaysched "Individuals who think the VSLA repayment schedule is inconvenient"
//N=3,401

*Individals who think the VSLA collateral security is unaffordable
lab var VSLA_op_highcollateral "Individuals who think the VSLA collateral security is unaffordable"
//N=3,401

*Individals who think VSLAs require a lot of pre-loan documentation
lab var VSLA_op_highdocument "Individuals who think VSLAs require a lot of documentation"
//N=3,401

*Individals who think VSLAs provide services in unsafe locations
lab var VSLA_op_unsafeloc "Individuals who think VSLAs provide services in unsafe locations"
//N=3,401

*Individals who think VSLAs have poor customer care
lab var VSLA_op_poorcustomerc "Individuals who think VSLAs have poor customer care"
//N=3,401

*Individals who don't understand VSLA contracts
lab var VSLA_op_poorcontract "Individuals who don't understand VSLA contracts"
//N=3,401

*Individals who were asked by VSLA staff to pay unofficial charges
lab var VSLA_op_unofficialcharge "Individuals who were asked by VSLA to pay unofficial charges"
//N=3,401

*Individals who think getting a VSLA loan takes a lot of time
lab var VSLA_op_toomuchtime "Individuals who think getting a VSLA loan takes a lot of time"
//N=3,401

*Individals who trust the lending behavior of SHGs
gen SHG_trust = .
lab var SHG_trust "Individuals who trust SHG lending behavior"
replace SHG_trust=0 if SACCO_trust==0 & VSLA_trust==0
replace SHG_trust=1 if SACCO_trust==1 | VSLA_trust==1
//N=3,401

*Individals who think SHGs lending has too high of an interest rate
gen SHG_op_highinterest = . 
lab var SHG_op_highinterest "Individuals who think the SHG interest rate is too high"
replace SHG_op_highinterest= 0 if SACCO_op_highinterest==0 | VSLA_op_highinterest==0
replace SHG_op_highinterest= 1 if SACCO_op_highinterest==1 | VSLA_op_highinterest==1
//N=3,401

*Individals who think the SHG grace period is short to start repaying the loan
gen SHG_op_shortgrace = . 
lab var SHG_op_shortgrace "Individuals who think the SHG grace period is too short"
replace SHG_op_shortgrace= 0 if SACCO_op_shortgrace==0 | VSLA_op_shortgrace==0
replace SHG_op_shortgrace= 1 if SACCO_op_shortgrace==1 | VSLA_op_shortgrace==1
//N=3,401

*Individals who think the SHG repayment schedule is inconvenient
gen SHG_op_badrepaysched = . 
lab var SHG_op_badrepaysched "Individuals who think the SHG repayment schedule is inconvenient"
replace SHG_op_badrepaysched= 0 if SACCO_op_badrepaysched==0 | VSLA_op_badrepaysched==0
replace SHG_op_badrepaysched= 1 if SACCO_op_badrepaysched==1 | VSLA_op_badrepaysched==1
//N=3,401

*Individals who think the SHG collateral security is unaffordable
gen SHG_op_highcollateral = . 
lab var SHG_op_highcollateral "Individuals who think the SHG collateral security is unaffordable"
replace SHG_op_highcollateral= 0 if SACCO_op_highcollateral==0 | VSLA_op_highcollateral==0
replace SHG_op_highcollateral= 1 if SACCO_op_highcollateral==1 | VSLA_op_highinterest==1
//N=3,401

*Individals who think SHGs require a lot of pre-loan documentation
gen SHG_op_highdocument = . 
lab var SHG_op_highdocument "Individuals who think SHGs require a lot of documentation"
replace SHG_op_highdocument= 0 if SACCO_op_highdocument==0 | VSLA_op_highdocument==0
replace SHG_op_highdocument= 1 if SACCO_op_highdocument==1 | VSLA_op_highdocument==1
//N=3,401

*Individals who think SHGs provide services in unsafe locations
gen SHG_op_unsafeloc = . 
lab var SHG_op_unsafeloc "Individuals who think SHGs provide services in unsafe locations"
replace SHG_op_unsafeloc= 0 if SACCO_op_unsafeloc==0 | VSLA_op_unsafeloc==0
replace SHG_op_unsafeloc= 1 if SACCO_op_unsafeloc==1 | VSLA_op_unsafeloc==1
//N=3,401

*Individals who think SHGs have poor customer care
gen SHG_op_poorcustomerc = . 
lab var SHG_op_poorcustomerc "Individuals who think SHGs have poor customer care"
replace SHG_op_poorcustomerc= 0 if SACCO_op_poorcustomerc==0 | VSLA_op_poorcustomerc==0
replace SHG_op_poorcustomerc= 1 if SACCO_op_poorcustomerc==1 | VSLA_op_poorcustomerc==1
//N=3,401

*Individals who don't understand SHG contracts
gen SHG_op_poorcontract = . 
lab var SHG_op_poorcontract "Individuals who don't understand SHG contracts"
replace SHG_op_poorcontract= 0 if SACCO_op_poorcontract==0 | VSLA_op_poorcontract==0
replace SHG_op_poorcontract= 1 if SACCO_op_poorcontract==1 | VSLA_op_poorcontract==1
//N=3,401

*Individals who were asked by SHG staff to pay unofficial charges
gen SHG_op_unofficialcharge = . 
lab var SHG_op_unofficialcharge "Individuals who were asked by SHG to pay unofficial charges"
replace SHG_op_unofficialcharge= 0 if SACCO_op_unofficialcharge==0 | VSLA_op_unofficialcharge==0
replace SHG_op_unofficialcharge= 1 if SACCO_op_unofficialcharge==1 | VSLA_op_unofficialcharge==1
//N=3,401

*Individals who think getting a SHG loan takes a lot of time
gen SHG_op_toomuchtime = . 
lab var SHG_op_toomuchtime "Individuals who think getting a SHG loan takes a lot of time"
replace SHG_op_toomuchtime= 0 if SACCO_op_toomuchtime==0 | VSLA_op_toomuchtime==0
replace SHG_op_toomuchtime= 1 if SACCO_op_toomuchtime==1 | VSLA_op_toomuchtime==1
//N=3,401

*Individuals who have negative opinions of SHGs 
gen SHG_op_negative = . 
la var SHG_op_negative "Individuals who have negative opinions of SHGs" 
replace SHG_op_negative = 0 if SHG_op_highinterest==0 & SHG_op_shortgrace==0 & SHG_op_badrepaysched==0 & SHG_op_highcollateral==0 & SHG_op_highdocument==0 ///
& SHG_op_unsafeloc==0 & SHG_op_poorcustomerc==0 & SHG_op_poorcontract==0 & SHG_op_unofficialcharge==0 & SHG_op_toomuchtime==0
replace SHG_op_negative = 1 if SHG_op_highinterest==1 | SHG_op_shortgrace==1 | SHG_op_badrepaysched==1 | SHG_op_highcollateral==1 | SHG_op_highdocument==1 ///
| SHG_op_unsafeloc==1 | SHG_op_poorcustomerc==1 | SHG_op_poorcontract==1 | SHG_op_unofficialcharge==1 | SHG_op_toomuchtime==1

************
*Proportion of individuals who find it easier to borrow with institutions now than in 2009 
************
*Individuals who find it easier to borrow with a SACCO
la var SACCO_easy_borrow "Individuals who find it easier to borrow with SACCO"
//N=731 - those who had previously taken a loan

*Individuals who find it easier to borrow with an ASCA
la var ASCA_easy_borrow "Individuals who find it easier to borrow with ASCA"
//N=710 - those who had previously taken a loan

*Individuals who find it easier to borrow with a VSLA
la var VSLA_easy_borrow "Individuals who find it easier to borrow with VSLA"
//N=776 - those who had previously taken a loan

*Individuals who find it easier to borrow with a savings group
la var SG_easy_borrow "Individuals who find it easier to borrow with savings group"
//N=710 - those who had previously taken a loan

*Individuals who find it easier to borrow with a ROSCA
la var ROSCA_easy_borrow "Individuals who find it easier to borrow with ROSCA"
//N=715 - those who had previously taken a loan

*Individuals who find it easier to borrow with an investment club
la var investclub_easy_borrow "Individuals who find it easier to borrow with investment club"
//N=704 - those who had previously taken a loan

*Individuals who find it easier to borrow with a burial society
la var burial_easy_borrow "Individuals who find it easier to borrow with burial society"
//N=710 - those who had previously taken a loan


*Individuals who find it easier to borrow with an SHG
gen SHG_easy_borrow = .
la var SHG_easy_borrow "Individuals who find it easier to borrow with an SHG"
replace SHG_easy_borrow = 0 if SACCO_easy_borrow==0 | ASCA_easy_borrow==0 | VSLA_easy_borrow==0 | /*
*/ SHG_easy_borrow==0 | ROSCA_easy_borrow==0 | investclub_easy_borrow==0
replace SHG_easy_borrow = 1 if SACCO_easy_borrow==1 | ASCA_easy_borrow==1 | VSLA_easy_borrow==1 | /*
*/ SHG_easy_borrow==1 | ROSCA_easy_borrow==1 | investclub_easy_borrow==1
//N=804 - those who had previously taken a loan

************
*Form of security required to obtain most recent loan from SHG
************ 
*Individuals that reported using a designated item for obtaining a SACCO loan 
gen SACCO_security_landtitle = . 
la var SACCO_security_landtitle "Individuals who report using a land title to obtain SACCO loan"
replace SACCO_security_landtitle=0 if SACCO_req_security!=1
replace SACCO_security_landtitle=1 if SACCO_req_security==1
//N=3,401

gen SACCO_security_household = . 
la var SACCO_security_household "Individuals who report using household assets to obtain SACCO loan"
replace SACCO_security_household=0 if SACCO_req_security!=2
replace SACCO_security_household=1 if SACCO_req_security==2
//N=3,401

gen SACCO_security_livestock = . 
la var SACCO_security_livestock "Individuals who report using livestock to obtain SACCO loan"
replace SACCO_security_livestock=0 if SACCO_req_security!=3
replace SACCO_security_livestock=1 if SACCO_req_security==3
//N=3,401

gen SACCO_security_car = . 
la var SACCO_security_car "Individuals who report using a car or motorcycle to obtain SACCO loan"
replace SACCO_security_car=0 if SACCO_req_security!=4
replace SACCO_security_car=1 if SACCO_req_security==4
//N=3,401

gen SACCO_security_machinery = . 
la var SACCO_security_machinery "Individuals who report using machinery or tools to obtain SACCO loan"
replace SACCO_security_machinery=0 if SACCO_req_security!=5
replace SACCO_security_machinery=1 if SACCO_req_security==5
//N=3,401

gen SACCO_security_shares = . 
la var SACCO_security_shares "Individuals who report using shares to obtain SACCO loan"
replace SACCO_security_shares=0 if SACCO_req_security!=6
replace SACCO_security_shares=1 if SACCO_req_security==6
//N=3,401

gen SACCO_security_insurance = . 
la var SACCO_security_insurance "Individuals who report using an insurance policy to obtain SACCO loan"
replace SACCO_security_insurance=0 if SACCO_req_security!=7
replace SACCO_security_insurance=1 if SACCO_req_security==7
//N=3,401

gen SACCO_security_other = . 
la var SACCO_security_other "Individuals who report using something else to obtain SACCO loan"
replace SACCO_security_other=0 if SACCO_req_security!=8
replace SACCO_security_other=1 if SACCO_req_security==8
//N=3,401

*Individuals that reported using a designated item for obtaining a RSCA/VSLA loan 
gen VSLA_security_landtitle = . 
la var VSLA_security_landtitle "Individuals who report using a land title to obtain RSCA/VSLA loan"
replace VSLA_security_landtitle=0 if VSLA_req_security!=1
replace VSLA_security_landtitle=1 if VSLA_req_security==1
//N=3,401

gen VSLA_security_household = . 
la var VSLA_security_household "Individuals who report using household assets to obtain RSCA/VSLA loan"
replace VSLA_security_household=0 if VSLA_req_security!=2
replace VSLA_security_household=1 if VSLA_req_security==2
//N=3,401

gen VSLA_security_livestock = . 
la var VSLA_security_livestock "Individuals who report using livestock to obtain RSCA/VSLA loan"
replace VSLA_security_livestock=0 if VSLA_req_security!=3
replace VSLA_security_livestock=1 if VSLA_req_security==3
//N=3,401

gen VSLA_security_car = . 
la var VSLA_security_car "Individuals who report using a car or motorcycle to obtain RSCA/VSLA loan"
replace VSLA_security_car=0 if VSLA_req_security!=4
replace VSLA_security_car=1 if VSLA_req_security==4
//N=3,401

gen VSLA_security_machinery = . 
la var VSLA_security_machinery "Individuals who report using machinery or tools to obtain RSCA/VSLA loan"
replace VSLA_security_machinery=0 if VSLA_req_security!=5
replace VSLA_security_machinery=1 if VSLA_req_security==5
//N=3,401

gen VSLA_security_shares = . 
la var VSLA_security_shares "Individuals who report using shares to obtain RSCA/VSLA loan"
replace VSLA_security_shares=0 if VSLA_req_security!=6
replace VSLA_security_shares=1 if VSLA_req_security==6
//N=3,401

gen VSLA_security_insurance = . 
la var VSLA_security_insurance "Individuals who report using an insurance policy to obtain RSCA/VSLA loan"
replace VSLA_security_insurance=0 if VSLA_req_security!=7
replace VSLA_security_insurance=1 if VSLA_req_security==7
//N=3,401

gen VSLA_security_other = . 
la var VSLA_security_other "Individuals who report using something else to obtain RSCA/VSLA loan"
replace VSLA_security_other=0 if VSLA_req_security!=8
replace VSLA_security_other=1 if VSLA_req_security==8
//N=3,401

*Individuals that reported using a designated item for obtaining an SHG loan 
gen SHG_security_landtitle = . 
la var SHG_security_landtitle "Individuals who report using a land title to obtain SHG loan"
replace SHG_security_landtitle=0 if SACCO_security_landtitle==0 & VSLA_security_landtitle==0
replace SHG_security_landtitle=1 if SACCO_security_landtitle==1 | VSLA_security_landtitle==1
//N=3,401

gen SHG_security_household = .
la var SHG_security_household "Individuals who report using household assets to obtain SHG loan"
replace SHG_security_household=0 if SACCO_security_household==0 & VSLA_security_household==0
replace SHG_security_household=1 if SACCO_security_household==1 | VSLA_security_household==1
//N=3,401

gen SHG_security_livestock = .
la var SHG_security_livestock "Individuals who report using livestock to obtain SHG loan"
replace SHG_security_livestock=0 if SACCO_security_livestock==0 & VSLA_security_livestock==0
replace SHG_security_livestock=1 if SACCO_security_livestock==1 | VSLA_security_livestock==1
//N=3,401

gen SHG_security_car = .
la var SHG_security_car "Individuals who report using a car or motorcycle to obtain SHG loan"
replace SHG_security_car=0 if SACCO_security_car==0 & VSLA_security_car==0
replace SHG_security_car=1 if SACCO_security_car==1 | VSLA_security_car==1
//N=3,401

gen SHG_security_machinery = .
la var SHG_security_machinery "Individuals who report using machinery or tools to obtain SHG loan"
replace SHG_security_machinery=0 if SACCO_security_machinery==0 & VSLA_security_machinery==0
replace SHG_security_machinery=1 if SACCO_security_machinery==1 | VSLA_security_machinery==1
//N=3,401

gen SHG_security_shares = .
la var SHG_security_shares "Individuals who report using shares to obtain SHG loan"
replace SHG_security_shares=0 if SACCO_security_shares==0 & VSLA_security_shares==0
replace SHG_security_shares=1 if SACCO_security_shares==1 | VSLA_security_shares==1
//N=3,401

gen SHG_security_insurance = .
la var SHG_security_insurance "Individuals who report using an insurance policy to obtain SHG loan"
replace SHG_security_insurance=0 if SACCO_security_insurance==0 & VSLA_security_insurance==0
replace SHG_security_insurance=1 if SACCO_security_insurance==1 | VSLA_security_insurance==1
//N=3,401

gen SHG_security_other = .
la var SHG_security_other "Individuals who report using something else to obtain SHG loan"
replace SHG_security_other=0 if SACCO_security_other==0 & VSLA_security_other==0
replace SHG_security_other=1 if SACCO_security_other==1 | VSLA_security_other==1
//N=3,401

gen SHG_security_all = . 
la var SHG_security_all "Individuals who report using some form of collateral to obtain an SHG loan"
replace SHG_security_all = 0 if SHG_security_landtitle==0 & SHG_security_household==0 & SHG_security_livestock==0 ///
& SHG_security_car==0 & SHG_security_machinery==0 & SHG_security_shares==0 & SHG_security_insurance==0 & SHG_security_other==0 
replace SHG_security_all = 1 if SHG_security_landtitle==1 | SHG_security_household==1 | SHG_security_livestock==1 ///
| SHG_security_car==1 | SHG_security_machinery==1 | SHG_security_shares==1 | SHG_security_insurance==1 | SHG_security_other==1 
//N=3,401

************
*Counts of products provided by SACCOs
************ 
*Individuals that currently use a savings account from a SACCO
la var SACCO_product_savings "Individuals that currently use a SACCO savings account"
//N=3,278

*Individuals that currently use a fixed deposit account from a SACCO
la var SACCO_product_fixeddep "Individuals that currently use a SACCO fixed deposit account"
//N=3,245

*Individuals that currently use a joint account from a SACCO
la var SACCO_product_joint "Individuals that currently use a SACCO joint account"
//N=3,259

*Individuals that currently use a current or cheque account from a SACCO
la var SACCO_product_current "Individuals that currently use a SACCO current or cheque account"
//N=3,243

*Individuals that currently use a ATM card/debit card from a SACCO
la var SACCO_product_ATM "Individuals that currently use a SACCO ATM or debit card"
//N=3,266

*Individuals that currently use a credit card from a SACCO
la var SACCO_product_creditcard "Individuals that currently use a SACCO credit card"
//N=3,252

*Individuals that currently use an investment or shares account from a SACCO
la var SACCO_product_investment "Individuals that currently use a SACCO investment or shares account"
//N=3,247

*Individuals that currently use a personal loan from a SACCO
la var SACCO_product_pers_loan "Individuals that currently use a SACCO personal loan"
//N=3,250

*Individuals that currently use overdraft from a SACCO
la var SACCO_product_overdraft "Individuals that currently use a SACCO overdraft"
//N=3,263

*Individuals that currently have a mortgage or lease from a SACCO
la var SACCO_product_mortgage "Individuals that currently use a SACCO mortgage or lease"
//N=3,262

*Individuals that currently have a home improvement loan from a SACCO
la var SACCO_product_homeimprove "Individuals that currently use a SACCO home improvement loan"
//N=3,248

*Individuals that currently have a commerical loan from a SACCO
la var SACCO_product_commercial "Individuals that currently use a SACCO commercial loan"
//N=3,240

*Individuals that currently use money transfer services (Western union, money gram) from a SACCO
la var SACCO_product_transfer "Individuals that currently use SACCO money transfer services"
//N=3,251

*Individuals that currently use obile money with a SACCO
la var SACCO_product_mobilebank "Individuals that currently use SACCO mobile banking"
//N=3,248

*Individuals that currently use cell banking with a SACCO
la var SACCO_product_cellbank "Individuals that currently use SACCO cell banking"
//N=3,240

*Individuals that currently use online banking with a SACCO
la var SACCO_product_onlinebank "Individuals that currently use SACCO online banking"
//N=3,204

*Individuals that currently use another product from a SACCO
la var SACCO_product_other "Individuals that currently use a SACCO for other products"
//N=1,041 - DJLS: not sure why this is so low, but probably should leave out of final indicators

************
*Other SHG information
************ 
*Individuals that reported losing property or assets to a SACCO
gen SACCO_lost_asset = 0 if c28 !=. 
la var SACCO_lost_asset "Individuals that reported having assets seized by a SACCO (failure to repay a loan)" //Of those who took a loan
replace SACCO_lost_asset = 1 if nc29_d==1
//N=1,206

*Individuals that reported losing property or assets to a VSLA
gen VSLA_lost_asset = 0 if c28 !=. 
la var VSLA_lost_asset "Individuals that reported having assets seized by a VSLA (failure to repay a loan)" //Of those who took a loan
replace VSLA_lost_asset = 1 if nc29_f==1
//N=1,203

*Individuals that reported losing property or assets to an SHG
gen SHG_lost_asset = . 
la var SHG_lost_asset "Individuals that reported losing property or assets to a SACCO" //Of those who took a loan
replace SHG_lost_asset = 0 if SACCO_lost_asset==0 | VSLA_lost_asset==0
replace SHG_lost_asset = 1 if SACCO_lost_asset==1 | VSLA_lost_asset==1
//N=1,206

**Generate Inverse Disaggregator Variables 

gen male = .
replace male = 1 if female == 0
replace male = 0 if female ==1

gen no_MM_use = .
replace no_MM_use = 1 if have_used_MM == 0
replace no_MM_use = 0 if have_used_MM ==1

gen no_phone = .
replace no_phone = 1 if have_phone == 0
replace no_phone = 0 if have_phone ==1

gen no_bank_acct = .
replace no_bank_acct = 1 if have_bank_acct == 0
replace no_bank_acct = 0 if have_bank_acct ==1

gen SHG_no_use = .
lab var SHG_no_use "Proportion of individuals who have not interacted with a SHG (Among all question respondents)"
replace SHG_no_use = 0 if SHG_use_any == 1
replace SHG_no_use = 1 if SHG_use_any == 0

************
*Disaggregate and Export
************ 
*create global of characteristic indicators
global disaggregation female rural have_phone have_bank_acct have_used_MM 

global cov_indicators SACCO_use_finserv VSLA_use_finserv ROSCA_use_finserv SG_current_loan ASCA_current_loan SHG_use_finserv SACCO_info_source SACCO_main_info_source SACCO_use_any burial_use_any SHG_use_any

global char_indicators SACCO_trust SACCO_op_highinterest SACCO_op_shortgrace SACCO_op_badrepaysched SACCO_op_highcollateral SACCO_op_highdocument SACCO_op_unsafeloc SACCO_op_poorcustomerc SACCO_op_poorcontract ///
SACCO_op_unofficialcharge SACCO_op_toomuchtime VSLA_trust VSLA_op_highinterest VSLA_op_shortgrace VSLA_op_badrepaysched VSLA_op_highcollateral VSLA_op_highdocument VSLA_op_unsafeloc VSLA_op_poorcustomerc ///
VSLA_op_poorcontract VSLA_op_unofficialcharge VSLA_op_toomuchtime SHG_trust SHG_op_negative SACCO_easy_borrow ASCA_easy_borrow VSLA_easy_borrow SG_easy_borrow ROSCA_easy_borrow investclub_easy_borrow ///
burial_easy_borrow SHG_easy_borrow SACCO_security_landtitle SACCO_security_household SACCO_security_livestock SACCO_security_car SACCO_security_machinery SACCO_security_shares SACCO_security_insurance ///
SACCO_security_other VSLA_security_landtitle VSLA_security_household VSLA_security_livestock VSLA_security_car VSLA_security_machinery VSLA_security_shares VSLA_security_insurance VSLA_security_other ///
SHG_security_all SACCO_product_* SACCO_lost_asset VSLA_lost_asset SHG_lost_asset 

*Create global of users vs. non-user indicators
	*ASCA, Burial society, ROSCA, SACCO, Savings Group, Village Saving/Lending Group, Investment Club
	gen VSLA_use_any = VSLA_use_finserv
	gen SG_use_finserv = SG_current_loan
	gen ASCA_use_finserv = ASCA_current_loan
	gen IC_use_finserv = IC_current_loan
	gen burial_use_finserv = burial_current_loan
	gen SG_use_any = SG_use_finserv
	gen ASCA_use_any = ASCA_use_finserv
	gen IC_use_any = IC_use_finserv
	gen ROSCA_use_any = ROSCA_use_finserv
	gen ASCA_no_use = .
	replace ASCA_no_use = 1 if ASCA_use_any == 0 
	replace ASCA_no_use = 0 if ASCA_use_any == 1
	gen burial_no_use = .
	replace burial_no_use = 1 if burial_use_any == 0
	replace burial_no_use = 0 if burial_use_any == 1
	gen ROSCA_no_use = .
	replace ROSCA_no_use = 1 if ROSCA_use_any == 0
	replace ROSCA_no_use = 0 if ROSCA_use_any == 1
	gen SACCO_no_use = .
	replace SACCO_no_use = 1 if SACCO_use_any == 0
	replace SACCO_no_use = 0 if SACCO_use_any == 1
	gen SG_no_use = .
	replace SG_no_use = 1 if SG_use_any == 0
	replace SG_no_use = 0 if SG_use_any == 1
	gen VSLA_no_use = .
	replace VSLA_no_use = 1 if VSLA_use_any == 0
	replace VSLA_no_use = 0 if VSLA_use_any == 1
	gen IC_no_use = .
	replace IC_no_use = 1 if IC_use_any == 0
	replace IC_no_use = 0 if IC_use_any == 1

global user_nonusers SHG_use_any SHG_no_use SHG_use_finserv SACCO_use_finserv SACCO_use_any SACCO_no_use VSLA_use_finserv VSLA_use_any VSLA_no_use ROSCA_use_finserv ROSCA_use_any ROSCA_no_use /*
*/ burial_use_any burial_no_use SG_no_use 


tab SHG_use_any 
tab SHG_no_use 
tab SHG_use_finserv 
tab SACCO_use_finserv 
tab SACCO_use_any 
tab SACCO_no_use 
tab VSLA_use_finserv 
tab VSLA_use_any 
tab VSLA_no_use 
tab ROSCA_use_finserv 
tab ROSCA_use_any 
tab ROSCA_no_use 
tab burial_use_finserv //only 23 observations 
tab burial_use_any 
tab burial_no_use 
tab SG_use_finserv //only 17 observations
tab SG_use_any 
tab SG_no_use 
tab ASCA_use_finserv //only 1 observation
tab ASCA_use_any //only 1 observation
tab ASCA_no_use 
tab IC_use_finserv //no observations
tab IC_use_any //no observations
tab IC_no_use //no observations


*Create global of country demographics
global country_demographics female male rural urban have_used_MM no_MM_use have_phone no_phone have_bank_acct no_bank_acct

*Create global of user/non-user disaggregators
global disagg_user_nonuser female male rural urban have_used_MM no_MM_use have_phone no_phone have_bank_acct no_bank_acct
 
*Coverage indicators
putexcel set "$final_data\UG_FinScope_estimates.xls", modify sheet("Coverage", replace)

svyset [pweight=pidmult] //We can't specify the correct strata and cluster units here which may affect the SE and CI
local row=2 //Start export into row 2

foreach v of global cov_indicators {
	quietly svy: mean `v'
	matrix prev_estimates=r(table)'
	matselrc prev_estimates mean_se, c(1 2 5 6) //need to install this package if Stata doesn't recognize this command
	putexcel 	A`row'="FinScope" C`row'="Coverage" I`row'="1.4 All individuals" ///
				L`row'="`v'" M`row'=matrix(mean_se) Q`row'=(e(N))
	local ++row
}	
		
foreach v of global cov_indicators {		
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
putexcel set "$final_data\UG_FinScope_estimates.xls", modify sheet("Characteristics")

svyset [pweight=pidmult] //We can't specify the correct strata and cluster units here which may affect the SE and CI
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
putexcel set "$final_data\UG_Finscope_estimates.xls", modify sheet("Users vs. Non-Users", replace)

svyset [pweight=pidmult] //We can't specify the correct strata and cluster units here which may affect the SE and CI
local row=2 //Start export into row 2
		
foreach v of global disagg_user_nonuser {		
	foreach x of global user_nonusers {		
			quietly svy, subpop(if `x'==1): mean `v'
			matrix prev_estimates=r(table)'
			matselrc prev_estimates mean_se, c(1 2 5 6)
			putexcel 	A`row'="Uganda" C`row'="FinScope" E`row'="Proportion of individuals who exhibit each characteristic" ///
						F`row'="`x'" H`row'="`v'=1" I`row'=matrix(mean_se) M`row'=(e(N_sub))
			local ++row
	}	
}



*Country Demographics indicators
putexcel set "$final_data\UG_FinScope_estimates.xls", modify sheet("Country Demographics", replace)

svyset [pweight=pidmult] //We can't specify the correct strata and cluster units here which may affect the SE and CI
local row=2 //Start export into row 2

		
foreach x of global country_demographics {		
			quietly svy : mean `x'
			matrix prev_estimates=r(table)'
			matselrc prev_estimates mean_se, c(1 2 5 6)
			putexcel 	A`row'="FinScope" C`row'="Demographics" I`row'="`x'=`1'" ///
						L`row'="`v'" M`row'=matrix(mean_se) Q`row'=(e(N))
			local ++row
		
}




