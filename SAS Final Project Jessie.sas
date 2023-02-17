*Creat lib, import data, rename data;
Libname Final "/home/u61683164/finalproject";

data d0531;
	set Final.cd0531;
	PS=Province_State;
	C_0531=confirmed;
	*rename columns;
	D_0531=Deaths;
	R_0531=Recovered;
	A_0531=Active;
	keep PS C_0531 D_0531 R_0531 A_0531;
run;

data d0601;
	set Final.cd0601;
	PS=Province_State;
	C_0601=confirmed;
	D_0601=Deaths;
	R_0601=Recovered;
	A_0601=Active;
	keep PS C_0601 D_0601 R_0601 A_0601;
run;

data d0602;
	set Final.cd0602;
	PS=Province_State;
	C_0602=confirmed;
	D_0602=Deaths;
	R_0602=Recovered;
	A_0602=Active;
	keep PS C_0602 D_0602 R_0602 A_0602;
run;

data d0603;
	set Final.cd0603;
	PS=Province_State;
	C_0603=confirmed;
	D_0603=Deaths;
	R_0603=Recovered;
	A_0603=Active;
	keep PS C_0603 D_0603 R_0603 A_0603;
run;

data d0604;
	set Final.cd0604;
	PS=Province_State;
	C_0604=confirmed;
	D_0604=Deaths;
	R_0604=Recovered;
	A_0604=Active;
	keep PS C_0604 D_0604 R_0604 A_0604;
run;

data d0605;
	set Final.cd0605;
	PS=Province_State;
	C_0605=confirmed;
	D_0605=Deaths;
	R_0605=Recovered;
	A_0605=Active;
	keep PS C_0605 D_0605 R_0605 A_0605;
run;

data d0606;
	set Final.cd0606;
	PS=Province_State;
	C_0606=confirmed;
	D_0606=Deaths;
	R_0606=Recovered;
	A_0606=Active;
	keep PS C_0606 D_0606 R_0606 A_0606;
run;

data d0607;
	set Final.cd0607;
	PS=Province_State;
	C_0607=confirmed;
	D_0607=Deaths;
	R_0607=Recovered;
	A_0607=Active;
	keep PS C_0607 D_0607 R_0607 A_0607;
run;

data region;
	set Final.region;
	PS=Province_State;
	keep PS Region;
RUN;

*Step 1: Using the mean procedure to get the total number of confirme at the beginning and the end of study;

proc univariate data=d0601;
run;

proc univariate data=d0607;
run;

*For ther beginning of the study(0601), there are 58 variables for the confirmed cases. And the total number of confirmed is 105149,
at the end of the study(0607), there are 58 variables for the confirmed cases, and the total number of confirmed cases is 110528;
*Step 2: Merge data;
*Sort date;

proc sort data=d0531 out=d0531;
	by PS;
run;

proc sort data=d0601 out=d0601;
	by PS;
run;

proc sort data=d0602 out=d0602;
	by PS;
run;

proc sort data=d0603 out=d0603;
	by PS;
run;

proc sort data=d0604 out=d0604;
	by PS;
run;

proc sort data=d0605 out=d0605;
	by PS;
run;

proc sort data=d0606 out=d0606;
	by PS;
run;

proc sort data=d0607 out=d0607;
	by PS;
run;

proc sort data=region out=region;
	by PS;
run;

*Merge data;

data FP;
	merge d0531 d0601 d0601 d0602 d0603 d0604 d0605 d0606 d0607 region;
	by PS;
run;

*Get the incidence case;

data FPQ2;
	set FP;
	IC0131=C_0601-C_0531;
	*get the new confirmed case for each day;
	IC0201=C_0602-C_0601;
	IC0302=C_0603-C_0602;
	IC0403=C_0604-C_0603;
	IC0504=C_0605-C_0604;
	IC0605=C_0606-C_0605;
	IC0706=C_0607-C_0606;
	KEEP PS region IC0131 IC0201 IC0302 IC0403 IC0504 IC0605 IC0706;
RUN;

proc univariate data=FPQ2;
run;

*Get the total number of new outcome.;
*IC0131 = 20848
 IC0201 = 20801
 IC0302 = 19699
 IC0403 = 21140
 IC0504 = 29972
 IC0605 = 23133
 IC0706 = 18117;
*graph;

data graph;
	Input days$ newoutcome;
	datalines;
  1 20848
  2 20801
  3 19699
  4 21140
  5 29972
  6 23133
  7 18117
   ;
run;

proc sgplot data=graph;
	scatter x=days y=newoutcome;
run;

*Step 3: Investigate by region;
*Merge d0601 with region, and get the average confirmed cases on date 0601;

data FPQ31;
	MERGE d0601 region;
	by PS;
RUN;

proc means data=FPQ31;
	class REGION;
	output out=avg_0601confirmed_region (drop=_type_ _freq_) 
		mean(C_0601)=TOTAL_0601_CF;
run;

*According to the output data, the average confirmed cases on Jun.1 for 
	Midwest is 29889.83, 
	Northeast is 86203.11, 
	Other is 828, 
	South is 26625.35, 
	West is 16891.61.


		 So, Northeast has the highest average confirmed cases on Jun.1.;
*Merge d0607 with region;

data FPQ32;
	MERGE d0607 region;
	by PS;
RUN;

proc means data=FPQ32;
	class REGION;
	output out=avg_0607confirmed_region (drop=_type_ _freq_) 
		mean(C_0607)=TOTAL_0607_CF;
run;

*According to the output data, the average confirmed cases on Jun.7 for 
	Midwest is 32341.91, 
	Northeast is 88187.71, 
	Other is 1052.4, 
	South is 29774.64, 
	West is 19269.69.


		 So, Northeast has the highest average confirmed cases on Jun.7;
*Step 4: investigate by state;

data d0601;
	set Final.cd0601;
	PS=Province_State;
	C_0601=confirmed;
	D_0601=Deaths;
	R_0601=Recovered;
	A_0601=Active;
	keep PS C_0601 D_0601 R_0601 A_0601;
run;

PROC sort data=d0601;
	BY descending C_0601;
run;

*According to the output data, the state which has the highest number of confirmed cases on Jun.1 is New York, 
 the state which has the lowest number of confirmed cases on Jun.1 is American Samoa.;

data d0607;
	set Final.cd0607;
	PS=Province_State;
	C_0607=confirmed;
	D_0607=Deaths;
	R_0607=Recovered;
	A_0607=Active;
	keep PS C_0607 D_0607 R_0607 A_0607;
run;

PROC sort data=d0607;
	BY descending C_0607;
run;

*According to the output data, the state which has the highest number of confirmed cases on Jun.7 is New York, 
 the state which has the lowest number of confirmed cases on Jun.7 is American Samoa.;

data d0701;
	set FP;
	total_case=C_0601+C_0602+C_0603+C_0604+C_0605+C_0606+C_0607;
run;

PROC SORT DATA=D0701;
	BY DESCENDING total_case;
RUN;

*According to the output data, the state which has the highest number of confirmed cases in the study period is New York, 
 the state which has the lowest number of confirmed cases in the study period is American Samoa.;
*Question 5;

data FPQ5;
	SET FP;
	WHERE PS in('Maine' 'Illinois' 'Guam' 'Texas' 'Utah');
	KEEP ps region C_0601 C_0602 C_0603 C_0604 C_0605 C_0606 C_0607;
RUN;

*graph;

proc sgplot data=FPQ5;
	scatter x=ps y=C_0601/ datalabel=region;
run;

proc sgplot data=FPQ5;
	scatter x=ps y=C_0602/ datalabel=region;
run;

proc sgplot data=FPQ5;
	scatter x=ps y=C_0603/ datalabel=region;
run;

proc sgplot data=FPQ5;
	scatter x=ps y=C_0604/ datalabel=region;
run;

proc sgplot data=FPQ5;
	scatter x=ps y=C_0605/ datalabel=region;
run;

proc sgplot data=FPQ5;
	scatter x=ps y=C_0606/ datalabel=region;
run;

proc sgplot data=FPQ5;
	scatter x=ps y=C_0607/ datalabel=region;
run;


proc sgplot data=FPQ5;
  scatter x=ps y=C_0601/ datalabel=region;
  scatter x=ps y=C_0602/ datalabel=region;
  scatter x=ps y=C_0603/ datalabel=region;
  scatter x=ps y=C_0604/ datalabel=region;
  scatter x=ps y=C_0605/ datalabel=region;
  scatter x=ps y=C_0606/ datalabel=region;
  scatter x=ps y=C_0607/ datalabel=region;
  run;


 proc sgplot data=FPQ5;
	reg x=ps y=C_0601 / lineattrs=(color=red thickness=2);
  Title "Scatter plot and regression line";
  run;





