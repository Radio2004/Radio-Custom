--Fusion monster test
local s,id=GetID()
function s.initial_effect(c)
	--Fusion materials
	c:EnableReviveLimit()
	Fusion.AddProcMixN(c,true,true,s.ffilter,2)
end
function s.ffilter(c,fc,sumtype,tp)
	return c:IsType(TYPE_MONSTER,fc,sumtype,tp) and c:IsCode(20447641,fc,sumtype,tp)
end
s.material={20447641}