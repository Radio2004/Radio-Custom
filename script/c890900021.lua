--Melirria, Episode of Fire and Ice
	local s,id=GetID()
	function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,id,EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	--Change battle poisition
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,0))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetHintTiming(0,TIMING_MAIN_END)
	e3:SetCountLimit(1,id)
	e3:SetCondition(s.thcon)
	e3:SetTarget(s.thtg)
	e3:SetOperation(s.thop)
	c:RegisterEffect(e3)
	--count
	aux.GlobalCheck(s,function()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end)
end
s.listed_series={0x1fa3}
	function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	if not g or #g~=1 then return false end
	local tc=g:GetFirst()
	e:SetLabelObject(tc)
	for tc in aux.Next(eg) do
		Duel.RegisterFlagEffect(tc:GetCardTargetCount(),id,RESET_PHASE+PHASE_END,0,1)
	end
end
	function s.filter(c)
	return c:IsSetCard(0x1fa3) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
	function s.thfilter(c,tp,e)
	return c:IsFaceup()  and c:IsLocation(LOCATION_MZONE) 
		 and (not e or c:IsCanBeEffectTarget(e)) and c:IsAbleToHand()
end
	function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(1-tp,id)>0 and Duel.IsMainPhase()
end
	--function s.thcon(e,tp,eg,ep,ev,re,r,rp)
	--local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	--if not g or #g~=1 then return false end
	--local tc=g:GetFirst()
	--e:SetLabelObject(tc)
	--return tc:IsLocation(LOCATION_MZONE) and re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x1fa3) and Duel.GetCurrentPhase()==PHASE_END
--end
	function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetCardTargetCount()
	if chk==0 then return tc:IsCanChangePosition() end
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetCardTargetCount()
	if tc and tc:IsFaceup() then
	Duel.ChangePosition(tc,POS_FACEUP_DEFENSE,0,POS_FACEUP_ATTACK,0)
	end
end