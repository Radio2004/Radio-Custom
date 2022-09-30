function Link.GetLinkCount(lc)
    return function(c)
        local te=c:IsHasEffect(890900032)
        local con
        if te then
            con=te:GetLabelObject()[1]
            if not con or con(lc) then return c:IsHasEffect(890900032) end
        end
        return c:IsHasEffect(890900032)
    end
end
