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
	--Apply effect depending
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1,id)
	e4:SetTarget(s.target)
	e4:SetOperation(s.operation)
	c:RegisterEffect(e4)
end
s.listed_series={0x7cc}
function s.cfilter2(c,att)
	return c:IsAttribute(att) and c:IsSetCard(0x7cc)
end
function s.ctfilter(c,tp)
	return c:IsAttribute(ATTRIBUTE_WIND) and c:IsSetCard(0x7cc)
end
function s.thfilter(c,e,tp)
	return c:IsSetCard(0x7cc) and aux.nvfilter(c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE) and c:IsAttribute(ATTRIBUTE_DARK)
end
function s.tgfilter(c,tp)
	return c:IsSetCard(0x7cc) and c:IsAttribute(ATTRIBUTE_LIGHT) and Duel.IsExistingMatchingCard(s.thfilter2,tp,LOCATION_DECK,0,1,nil)
end
function s.thfilter2(c)
	return c:IsSetCard(0x7cc) and c:IsMonster() and c:IsAbleToHand()
end
function s.spfilter(c)
	return c:IsSetCard(0x7cc) and c:IsSpellTrap() and c:IsAbleToHand()
end

function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local remove=Duel.GetMatchingGroup(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	local g1=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
	and Duel.IsExistingTarget(s.thfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	local g2=Duel.IsExistingTarget(s.tgfilter,tp,LOCATION_GRAVE,0,1,nil,tp)
	local g3=Duel.IsExistingTarget(s.cfilter2,tp,LOCATION_GRAVE,0,1,nil,ATTRIBUTE_EARTH) and Duel.IsPlayerCanDraw(tp,1)
	local g4=Duel.IsExistingTarget(s.cfilter2,tp,LOCATION_GRAVE,0,1,nil,ATTRIBUTE_WATER) and #g>0
	local g5=Duel.IsExistingMatchingCard(Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) and Duel.IsExistingTarget(s.cfilter2,tp,LOCATION_GRAVE,0,1,nil,ATTRIBUTE_FIRE)
	local g6=Duel.IsExistingTarget(s.ctfilter,tp,LOCATION_GRAVE,0,1,nil,tp) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>=5
	local b1=g1  
	local b2=g2
	local b3=g3
	local b4=g4
	local b5=g5
	local b6=g6
	if chk==0 then return b1 or b2 or b3 or b4 or b5 end
	local op=Duel.SelectEffect(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)},
		{b3,aux.Stringid(id,2)},
		{b4,aux.Stringid(id,3)},
		{b5,aux.Stringid(id,4)},
		{b6,aux.Stringid(id,5)})
		e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectTarget(tp,s.thfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	elseif op==2 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local tg=Duel.SelectTarget(tp,s.tgfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,tg,1,tp,0)
	elseif op==3 then
		e:SetCategory(CATEGORY_DRAW)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		Duel.SelectTarget(tp,s.cfilter2,tp,LOCATION_GRAVE,0,1,1,nil,ATTRIBUTE_EARTH)
		Duel.SetTargetPlayer(tp)
		Duel.SetTargetParam(1)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	elseif op==4 then
		e:SetCategory(CATEGORY_DESTROY)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		Duel.SelectTarget(tp,s.cfilter2,tp,LOCATION_GRAVE,0,1,1,nil,ATTRIBUTE_WATER)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
	elseif op==5 then
		e:SetCategory(CATEGORY_REMOVE)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		Duel.SelectTarget(tp,s.cfilter2,tp,LOCATION_GRAVE,0,1,1,nil,ATTRIBUTE_FIRE)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,remove,1,0,0)
	elseif op==6 then
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local tg=Duel.SelectTarget(tp,s.ctfilter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
		Duel.SetTargetPlayer(tp)
		Duel.SetPossibleOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
	end
end
function s.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local op=e:GetLabel()
	local tc=Duel.GetFirstTarget()
	if op==1 then
		if tc and tc:IsRelateToEffect(e) then
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
		end
	elseif op==2 then
		if not tc:IsRelateToEffect(e) then return end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter2,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	elseif op==3 then
		local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
		Duel.Draw(p,d,REASON_EFFECT)
	elseif op==4 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if #g>0 then
			Duel.HintSelection(g)
			Duel.Destroy(g,REASON_EFFECT)
		end
	elseif op==5 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToRemove,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
		if #g>0 then
			Duel.Remove(g,POS_FACEUP,REASON_EFFECT)
		end
	elseif op==6 then
		local p=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER)
		local ac=5
		Duel.ConfirmDecktop(p,ac)
		local g=Duel.GetDecktopGroup(p,ac)
		if #g>0 and g:IsExists(s.spfilter,1,nil) then
			Duel.Hint(HINT_SELECTMSG,p,HINTMSG_ATOHAND)
			local sg=g:FilterSelect(p,s.spfilter,1,1,nil)
			Duel.DisableShuffleCheck()
			Duel.SendtoHand(sg,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-p,sg)
			Duel.ShuffleHand(p)
			ac=ac-1
		end
		if ac>0 then
			Duel.MoveToDeckBottom(ac,tp)
			Duel.SortDeckbottom(tp,tp,ac)
		end
	end
end