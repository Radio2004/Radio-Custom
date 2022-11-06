--Attackers and Blockers - Fire Warrior
local s,id=GetID()
function s.initial_effect(c)
	--fusion material
	c:EnableReviveLimit()
	Fusion.AddProcMixN(c,false,false,aux.FilterBoolFunctionEx(Card.IsSetCard,0x14f1),1,s.ffilter,1)
end
s.material_setcode={0x14f1}
function s.ffilter(c,fc,sumtype,tp,sub,mg,sg)
	return c:GetBaseAttack()~=c:GetAttack()
end

