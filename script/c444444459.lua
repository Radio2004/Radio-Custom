--Myra, Novella Girl - Offence
local s,id=GetID()
function s.initial_effect(c)
--Link summon 
	Link.AddProcedure(c,aux.FilterBoolFunctionEx(Card.IsSetCard,0x1BC),2,2)
 -- Effects
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,3))
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.destg)
	e1:SetOperation(s.desop)
	c:RegisterEffect(e1)
end
s.listed_series={0x1BC}
function s.filter(c)
	return c:IsSetCard(0x1BC) and c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
	end
	function s.recfilter(c)
	return c:IsFaceup() and c:GetBaseAttack()>0
end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.IsExistingMatchingCard(s.filter,tp,LOCATION_DECK,0,1,nil)
	local g2=Duel.IsExistingTarget(s.recfilter,tp,0,LOCATION_MZONE,1,nil)
	local b1=g1
	local b2=g2
	if chk==0 then return b1 or b2 end
	local op=aux.SelectEffect(tp,
		{b1,aux.Stringid(id,0)},
		{b2,aux.Stringid(id,1)})
	e:SetLabel(op)
	if op==1 then
		e:SetCategory(CATEGORY_TOGRAVE)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
	else
		e:SetCategory(CATEGORY_RECOVER)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
		local g=Duel.SelectTarget(tp,s.recfilter,tp,0,LOCATION_MZONE,1,1,nil)
		Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetBaseAttack())
	end
end
function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetLabel()==1 then
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.filter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
end
	else
	if e:GetHandler():IsRelateToEffect(e) and tc:IsFaceup() and tc:IsRelateToEffect(e) then
		Duel.Recover(tp,tc:GetBaseAttack(),REASON_EFFECT)
		end
	end
end
