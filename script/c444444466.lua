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
		   and c:IsSetCard(0x1bc) and not c:IsCode(id)
end

function s.schfilter(c)
	return c:IsSetCard(0x1BC) and c:IsAbleToHand() and not c:IsCode(id)
end

function s.bantg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(s.smfilter,tp,LOCATION_GRAVE,0,nil,tp)
	local dnc=math.min(g:GetClassCount(Card.GetCode))
	local b1=dnc>3 and Duel.IsExistingMatchingCard(s.schfilter,tp,LOCATION_GRAVE,0,1,e:GetHandler())
	local b2=dnc>6 and Duel.IsPlayerCanDraw(tp,1)
	local b3=dnc>9 and Duel.IsExistingMatchingCard(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,nil)
	if chk==0 then return b1 or b2 or b3 end
	local op=aux.SelectEffect(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)},
		{b3,aux.Stringid(id,2)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
	elseif op==2 then
		e:SetCategory(CATEGORY_DRAW+CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	else
		e:SetCategory(CATEGORY_TODECK)
		local g=Duel.GetMatchingGroup(Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,g,1,0,0)
	end
end

function s.banop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	local g=Duel.GetMatchingGroup(s.smfilter,tp,LOCATION_GRAVE,0,nil,tp)
	local dnc=g:GetClassCount(Card.GetCode)
	if dnc==0 then return end
	if op==1 and dnc>3 then
		if not e:GetHandler():IsRelateToEffect(e) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.schfilter,tp,LOCATION_GRAVE,0,1,1,c)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
	end
	elseif op==2 and dnc>6 then
	   if Duel.Draw(tp,1,REASON_EFFECT)==0 then return end
	   local tc=Duel.GetOperatedGroup():GetFirst()
	   if tc:IsType(TYPE_MONSTER) and tc:IsSetCard(0x1bc) then
	   if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	   if tc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
			Duel.ConfirmCards(1-tp,tc)
			Duel.BreakEffect()
	   if Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
			tc:RegisterEffect(e2)
			end
	  end
end
	elseif op==3 and dnc>3 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
		local sg=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,0,LOCATION_ONFIELD,1,1,nil)
		if #sg>0 then
		Duel.HintSelection(sg)
		Duel.SendtoDeck(sg,nil,2,REASON_EFFECT)
		end
	end
end