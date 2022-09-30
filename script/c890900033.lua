--Gaiden Melirria - Kaede & Naoki
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterSummonCode(890900035),1,1,aux.FilterSummonCode(890900036),1,1)
	c:EnableReviveLimit()
end
