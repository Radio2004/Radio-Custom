--Attackers and Blockers Fusion
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Fusion.CreateSummonEff(c,aux.FilterBoolFunction(Card.IsSetCard,0x14f1),nil,s.fextra)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
end
s.listed_series={0x14f1}
function s.exfilter0(c)
	return c:GetBaseAttack()~=c:GetAttack() and c:IsAbleToGrave()
end
function s.matlimit(c)
	return c:GetBaseAttack()~=c:GetAttack()
end
function s.fcheck(tp,sg,fc)
	return sg:FilterCount(s.matlimit,nil)<=1
end
function s.fextra(e,tp,mg)
	local sg=Duel.GetMatchingGroup(s.exfilter0,tp,0,LOCATION_ONFIELD,nil)
	if #sg>0 then
		return sg,s.fcheck
	end
	return nil
end