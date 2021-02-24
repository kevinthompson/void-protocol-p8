-- quicksort by JWinslow23

function quick_sort_hp(tbl,lo,hi)
  lo,hi=lo or 1,hi or #tbl
  if lo<hi then
      local p,i,j=tbl[(lo+hi)\2].layer,lo-1,hi+1
      while true do
          repeat i+=1 until tbl[i].layer>=p
          repeat j-=1 until tbl[j].layer<=p
          if (i>=j) break
          tbl[i],tbl[j]=tbl[j],tbl[i]
      end
      quick_sort_hp(tbl,lo,j)
      quick_sort_hp(tbl,j+1,hi)
  end
end