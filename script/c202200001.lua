--The Wonder of World Mouse Archer
local s,id=GetID()
function s.initial_effect(c)
	--spirit return
	aux.EnableSpiritReturn(c,EVENT_SUMMON_SUCCESS,EVENT_FLIP)
	--cannot special summon
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e1:SetValue(aux.FALSE)
	c:RegisterEffect(e1)
	--Reveal
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCondition(s.spcon)
	e2:SetCountLimit(1)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
end
function s.filter(c)
	return c:IsType(TYPE_SPIRIT)
end
function s.schfilter(c)
	return c:IsSetCard(0x1e61) and not c:IsCode(id) and c:IsAbleToHand()
end
function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>0 and e:GetHandler():GetFlagEffect(id)==0
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return not Duel.IsExistingMatchingCard(Card.IsPublic,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.SetTargetPlayer(tp)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
	local ct=Duel.GetFieldGroup(p,LOCATION_HAND,0)
	Duel.ConfirmCards(1-p,ct)
	Duel.ShuffleHand(p)
	if ct==1 then return end
		Duel.BreakEffect()
	   local g=Duel.GetMatchingGroup(s.filter,tp,LOCATION_HAND,0,nil)
	   if #g>=2 and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
	   local f=Duel.GetMatchingGroupCount(s.filter,tp,LOCATION_HAND,0,nil)
	   Duel.Damage(1-p,f*200,REASON_EFFECT)
end
local g1=Duel.GetMatchingGroup(s.schfilter,tp,LOCATION_DECK,0,nil,tp)
if #g>=3 and #g1>0 and Duel.SelectYesNo(tp,aux.Stringid(id,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local k=Duel.SelectMatchingCard(tp,s.schfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #k>0 then
			Duel.SendtoHand(k,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,k)
end
end
end


 
  
   

	



