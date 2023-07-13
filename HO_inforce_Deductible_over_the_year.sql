drop table if exists Competitive.dbo.TT_HO_Ded

CREATE TABLE Competitive.dbo.TT_HO_Ded
(
Yr int  
,st varchar(2)
,policy_eff_date date--Policy Effective Date', --as '
,POL_SQL_KEY varchar(14)	
,policy_exp_date date
	  --,Policy.state	
	  ,DATA_SOURCE_CC varchar(3)
	  --,POLICY_EFF_DATE
	  --,Rating.POL_SQL_KEY		
	  ,POLICY_NUMBER varchar(10)
	  ,DWELLING_LIMIT decimal(18,2)
	  ,DEDUCTIBLE_TYPE varchar(1)
,DEDUCTIBLE_AMOUNT decimal(18,2)
,ALL_PERIL_DEDUCT decimal(18,2)
,WIND_HAIL_DEDUCT decimal(18,2)
,HURRICANE_DEDUCT decimal(18,2)
)

DECLARE @year int = 2011
--print @year
Declare @dt datetime

--SET @dt = cast(@year+'-11-30'as date)
--print @dt
--'2011-11-30'		
----DECLARE @State char(2)		
----SET @State = 'KS'

while @year <= 2021
begin
set @year = @year+1
SET @dt = datefromparts(@year,'12','31')
INSERT INTO Competitive.dbo.TT_HO_Ded

select distinct @year as Yr
,  Policy.state as st,
	  Policy.policy_eff_date --as 'Policy Effective Date'
	  ,Policy.POL_SQL_KEY	
	  ,Policy.policy_exp_date	
	  --,Policy.state	
	  ,Rating.DATA_SOURCE_CC
	  --,POLICY_EFF_DATE
	  --,Rating.POL_SQL_KEY		
	  ,Rating.POLICY_NUMBER
	  ,Rating.DWELLING_LIMIT
	  ,Rating.DEDUCTIBLE_TYPE
,Rating.DEDUCTIBLE_AMOUNT
,Rating.ALL_PERIL_DEDUCT
,Rating.WIND_HAIL_DEDUCT
,Rating.HURRICANE_DEDUCT --top 5 rtng.POL_SQL_KEY,rtng.STATE,,form
--INTO #TT_HO_Ded
from HDB_HOME.[dbo].[PIDHST_HPROP_RATNG] Rating,
[HDB_HOME].[dbo].[PIDHST_HPOLICY] as Policy
where Rating.POL_SQL_KEY = Policy.POL_SQL_KEY		
	--and Policy.policy_pointer = Pointer.policy_pointer
	--and Pointer.policy_pointer = Hforms.policy_pointer
	----and Policy.POLICY_EFF_DATE <= @year
	and Policy.POLICY_EXP_DATE > @dt
	--and Rating.state = @State
	--and ds.PSC_ST_CD = @State
	--and @year between Policy.POLICY_EFF_DATE and (Policy.POLICY_EXP_DATE + 10)
	--and @year between Rating.hist_beg_eff_ts and (Rating.hist_end_eff_ts + 10)
	--and @year between Policy.hist_beg_eff_ts and (Policy.hist_end_eff_ts + 10)
	and @dt between Policy.POLICY_EFF_DATE and Policy.POLICY_EXP_DATE
	and @dt between Rating.hist_beg_eff_ts and Rating.hist_end_eff_ts
	and @dt between Policy.hist_beg_eff_ts and Policy.hist_end_eff_ts
	and Rating.FORM = 'HO3'
	and (Policy.UND_C5_POL_STATUS <>'Cancelled'  -- indicates policy cancellation		
	or	
	Policy.UND_C5_POL_STATUS = 'Cancelled'  -- indicates policy cancellation
	and exists	
	(select m.trans_eff_date	
	from HDB_Home.dbo.pidhst_hpremium m	
	where Policy.POL_SQL_KEY=m.POL_SQL_KEY	
	and m.tran_code = 'Cancellation'  
	and m.trans_eff_date > @dt))	
order by policy.state,policy_number,policy.policy_eff_date


--print @year
end

--print 'stop'
go
--union all
select * from Competitive.dbo.TT_HO_Ded
--select min(policy_eff_date) minn,max(policy_eff_date) maxx from #TT_HO_Ded