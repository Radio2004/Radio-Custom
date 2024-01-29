--Night Slasher, Ragnara
local s,id=GetID()
function s.initial_effect(c)
	--synchro summon
	Synchro.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0xcf),1,1,Synchro.NonTunerEx(Card.IsSetCard,0xcf),1,99)
	c:EnableReviveLimit()
	--Increase ATK/DEF
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetValue(s.atkval)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e2)
	--Decrease ATK/DEF
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_UPDATE_ATTACK)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,LOCATION_MZONE)
	e3:SetValue(s.val)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e4)
	--Destroy replace
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e5:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e5:SetCode(EFFECT_DESTROY_REPLACE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(s.desreptg)
	c:RegisterEffect(e5)
	--Banish
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(id,0))
	e6:SetCategory(CATEGORY_POSITION+CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetCode(EVENT_REMOVE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(1,id)
	e6:SetTarget(s.remtg)
	e6:SetOperation(s.remop)
	c:RegisterEffect(e6)
end
s.listed_series={0xcf}
function s.atkval(e,c)
	return Duel.GetMatchingGroupCount(Card.IsSetCard,c:GetControler(),LOCATION_REMOVED,LOCATION_REMOVED,nil,0xcf)*100
end
function s.val(e,c)
	return Duel.GetMatchingGroupCount(Card.IsSetCard,c:GetControler(),LOCATION_REMOVED,LOCATION_REMOVED,nil,0xcf)*(-100)
end
function s.repfilter(c)
	return c:IsAbleToRemove() and aux.SpElimFilter(c,true) and c:IsSetCard(0xcf)
end
function s.desreptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return not c:IsReason(REASON_REPLACE) and c:IsReason(REASON_EFFECT)
		and Duel.IsExistingMatchingCard(s.repfilter,tp,LOCATION_MZONE|LOCATION_GRAVE,0,1,c) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESREPLACE)
		local g=Duel.SelectMatchingCard(tp,s.repfilter,tp,LOCATION_MZONE|LOCATION_GRAVE,0,1,1,c)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		return true
	else return false end
end
function s.posfilter(c)
	return c:IsFacedown() and c:IsDefensePos() and c:IsCanChangePosition()
end
function s.spfilter(c,e,tp)
	return c:IsSetCard(0xcf) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.remtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(s.spfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_POSITION,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_REMOVED)
end
function s.remop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local tc=Duel.SelectMatchingCard(tp,s.posfilter,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil):GetFirst()
	if tc and Duel.ChangePosition(tc,POS_FACEUP_DEFENSE)~=0 then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,s.spfilter,tp,LOCATION_DECK+LOCATION_REMOVED,0,1,1,nil,e,tp)
		local tg=g:GetFirst()
		if tg then
			Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
			local fid=e:GetHandler():GetFieldID()
			tg:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,1,fid)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PHASE+PHASE_END)
			e1:SetCountLimit(1)
			e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e1:SetLabel(fid)
			e1:SetLabelObject(tg)
			e1:SetCondition(s.thcon)
			e1:SetOperation(s.thop)
			Duel.RegisterEffect(e1,tp)
		end
	end
end
function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(id)~=e:GetLabel() then
		e:Reset()
		return false
	else return Duel.GetTurnPlayer()==tp end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoHand(e:GetLabelObject(),nil,REASON_EFFECT)
end