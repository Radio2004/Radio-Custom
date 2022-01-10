--Myra, Novella Girl
local s,id=GetID()
function s.initial_effect(c)
  -- Effects
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY+EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetTarget(s.destg)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e2)
	--Limit battle target
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	e3:SetCondition(s.atcon)
	e3:SetValue(aux.imval1)
	c:RegisterEffect(e3)
	end
	s.listed_series={0x1BC}
	function s.atcon(e)
	return Duel.IsExistingMatchingCard(aux.FilterFaceupFunction(Card.IsSetCard,0x1BC),e:GetOwnerPlayer(),LOCATION_MZONE,0,1,e:GetHandler())
end
function s.filter(c)
	return c:IsFaceup() and c:GetAttack()>0 
end
function s.thfilter(c)
	return c:IsSetCard(0x1BC) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
	end
function s.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=s.thtg(e,tp,eg,ep,ev,re,r,rp,0)
	local g2=s.pencon(e,tp,eg,ep,ev,re,r,rp,0)
	local b1=g1
	local b2=g2
	if chk==0 then return b1 or b2 end
	local ops={}
	local opval={}
	local off=1
	if b1 then
		ops[off]=aux.Stringid(id,0)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(id,1)
		opval[off-1]=2
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	if sel==1 then
		e:SetOperation(s.thop)
		s.thtg(e,tp,eg,ep,ev,re,r,rp,1)
	elseif sel==2 then
		e:SetCode(EVENT_BATTLE_DAMAGE)
		e:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
		e:SetTarget(s.pentg)
		e:SetOperation(s.penop)
		s.pencon(e,tp,eg,ep,ev,re,r,rp,1)
	else
		e:SetCategory(0)
		e:SetOperation(nil)
	end
end
function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.GetFlagEffect(tp,id)==0 and Duel.IsExistingTarget(s.filter,tp,0,LOCATION_MZONE,1,nil) end
Duel.RegisterFlagEffect(tp,id,RESET_PHASE+PHASE_END,0,1)
end
function s.thop(e,tp,eg,ep,ev,re,r,rp)
if not e:GetHandler():IsRelateToEffect(e) then return end
Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	local g=Duel.SelectTarget(tp,s.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,g:GetFirst():GetAttack())
	local tc=Duel.GetFirstTarget(tp,0)
	if tc:IsRelateToEffect(e) and tc:IsFaceup()and tc:IsControler(1-tp) and tc:GetAttack()>0 then
		Duel.Recover(tp,tc:GetAttack(),REASON_EFFECT)
end
end
function s.pencon(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	return ep~=tp and tc:IsControler(tp) and tc:IsSetCard(0x1bc) and tc~=e:GetHandler()
end
function s.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
if chk==0 then return Duel.GetFlagEffect(tp,id+1)==0 and Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.RegisterFlagEffect(tp,id+1,RESET_PHASE+PHASE_END,0,1)
end
function s.penop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if #g>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end

