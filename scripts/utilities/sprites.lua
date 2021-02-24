function mapr(x,y,rot,mx,my,w,flip,scale)
  flip = flip or false
  scale = scale or 1
  w+=.8
  local halfw, cx  = scale*-w/2, mx + w/2 -.4
  local cs, ss, cy = cos(rot)/scale, -sin(rot)/scale, my-halfw/scale-.4
  local sx, sy, hx, hy = cx + cs*halfw, cy - ss*halfw, w*(flip and -4 or 4)*scale, w*4*scale

  for py = y-hy, y+hy do
    tline(x-hx, py, x+hx, py, sx + ss*halfw, sy + cs*halfw, cs/8, -ss/8)
    halfw+=1/8
  end
end

function transparent(func)
  if flr((t() * 1000)) % 2 == 0 then
    func()
  end
end