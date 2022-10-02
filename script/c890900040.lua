--Crimson Possessed - Iori Nakanishi
local s,id=GetID()
function s.initial_effect(c)
	--Fusion Procedure
	c:EnableReviveLimit()
	Fusion.AddProcMix(c,true,true,890900024,s.ffilter)
end
s.listed_names={890900024}
function s.ffilter(c,fc,sumtype,tp)
	return c:IsAttribute(ATTRIBUTE_DARK,fc,sumtype,tp) and c:IsSetCard(0x3dd,fc,sumtype,tp)
end
