--Virtuality network - Nebula World
local s,id=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsSetCard,0x7cc))
	e2:SetValue(500)
	c:RegisterEffect(e2)
	--defup
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UPDATE_DEFENSE)
	c:RegisterEffect(e3)
	--Apply effect depending on the target's position
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES+CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DESTROY+CATEGORY_REMOVE+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,id)
	e4:SetTarget(s.target)
	e4:SetOperation(s.operation)
	c:RegisterEffect(e4)
end
s.listed_series={0x7cc}
function s.tgfilter(c,e,tp,tc)
	return c:IsMonster() and c:IsSetCard(0x7cc) and (s.addfilter(c,tc) or s.spfilter(c,e,tp) or s.drawfilter(c,tp) or s.desfilter(c,tp) or s.rmfilter(c,tp) or s.sfilter(c,tp))
end
function s.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function s.addfilter(c,tc)
	return Duel.IsExistingMatchingCard(s.thfilter,0,LOCATION_DECK,0,1,tc,c:GetCode()) and c:IsAttribute(ATTRIBUTE_LIGHT)
end
function s.desfilter(c,tp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil)
	return c:IsAttribute(ATTRIBUTE_WATER) and #g>0
end
function s.sfilter(c,tp)
	local ct=c:GetLevel()
   return c:IsAttribute(ATTRIBUTE_WIND) and Duel.IsPlayerCanDiscardDeck(tp,ct)
end
function s.drawfilter(c,tp)
   return Duel.IsPlayerCanDraw(tp,1) and c:IsAttribute(ATTRIBUTE_EARTH)
end
function s.spfilter(c,e,tp)
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and aux.nvfilter(c)
		and c:IsAttribute(ATTRIBUTE_DARK)
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function s.rmfilter(c,tp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	return #g>0 and c:IsAttribute(ATTRIBUTE_FIRE)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and s.tgfilter(chkc,e,tp,c) end
	if chk==0 then return Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp,c)
	local tc=g:GetFirst()
	if tc:IsAttribute(ATTRIBUTE_DARK) then
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
	end
	if tc:IsAttribute(ATTRIBUTE_LIGHT) then
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
	if tc:IsAttribute(ATTRIBUTE_EARTH) then
		e:SetCategory(CATEGORY_DRAW)
		e:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	end
	if tc:IsAttribute(ATTRIBUTE_WATER) then
		local tg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
	end
	if tc:IsAttribute(ATTRIBUTE_FIRE) then
		local tg=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,tg,1,0,LOCATION_ONFIELD)
	end
	if tc:IsAttribute(ATTRIBUTE_WIND) then
		Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,tc:GetLevel())
	end
	Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DESTROY,1,1,0,0)
	Duel.SetPossibleOperationInfo(0,CATEGORY_REMOVE,1,1,0,LOCATION_ONFIELD)
	Duel.SetPossibleOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,tc:GetLevel())
	Duel.SetPossibleOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,tp,LOCATION_GRAVE)
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not (tc and tc:IsRelateToEffect(e)) then return end
	local b1=s.addfilter(tc,c)
	local b2=s.spfilter(tc,e,tp)
	local b3=s.drawfilter(tc,tp)
	local b4=s.desfilter(tc,tp)
	local b5=s.rmfilter(tc,tp)
	local b6=s.sfilter(tc,tp)
	if b1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil,tc:GetCode())
		if #sg>0 then
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,sg)
		end
	elseif b2 then
		--Special Summon
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	elseif  b3 then
			local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
			Duel.Draw(p,d,REASON_EFFECT)
	elseif b4 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
			local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	elseif b5 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if #g>0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	elseif b6 then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		local lv=tc:GetLevel()
		if tc:IsRelateToEffect(e) and lv>0 then
			Duel.DiscardDeck(tp,lv,REASON_EFFECT)
		end
	end
end