--Novella's Judgement
local s,id=GetID()
function s.initial_effect(c)
	--Active 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.bantg)
	e1:SetOperation(s.banop)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	c:RegisterEffect(e1)
end
s.listed_series={0x1bc}
	function s.smfilter(c,tp)
	return c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp)
		   and c:IsSetCard(0x1bc)
end

function s.schfilter(c)
	return c:IsSetCard(0x1BC) and c:IsAbleToHand()
end

function s.bantg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.smfilter,tp,LOCATION_GRAVE,0,e:GetHandler(),tp)
	local dnc=math.min(g:GetClassCount(Card.GetCode))
	local b1=dnc>3 and Duel.IsExistingMatchingCard(s.schfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler())
	local b2=dnc>6
	local b3=dnc>9
	if chk==0 then return b1 or b2 or b3 end
	local op=aux.SelectEffect(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)},
		{b3,aux.Stringid(id,2)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	end
end
function s.banlocop(tp,loc,gf)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,0,loc,nil)
	if #g>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local sg=gf(g,tp,1,1,nil)
		Duel.HintSelection(sg,true)
		return Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
	return 0
end
function s.banop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	local g=Duel.GetMatchingGroup(s.smfilter,tp,LOCATION_GRAVE,0,c,tp)
	local dnc=g:GetClassCount(Card.GetCode)
	if dnc==0 then return end
	if op==1 then
		if not e:GetHandler():IsRelateToEffect(e) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.schfilter,tp,LOCATION_GRAVE,0,1,1,c)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
	end
	elseif op==2 then
		if not e:GetHandler():IsRelateToEffect(e) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.schfilter,tp,LOCATION_GRAVE,0,1,1,c)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
	end
	else
		 if not e:GetHandler():IsRelateToEffect(e) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.schfilter,tp,LOCATION_GRAVE,0,1,1,c)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end