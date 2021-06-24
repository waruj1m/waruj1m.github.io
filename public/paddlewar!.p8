pico-8 cartridge // http://www.pico-8.com
version 32
__lua__
function _init()
    cls()
            -- variables
     pad_x=52
     pad_y=120
     pad_w=24
     pad_h=3
     pad_c=11
     
     cpad_x=52
     cpad_y=9
     cpad_w=24
     cpad_h=3
     
     
     
     ball_x=6
     ball_dx=2
     ball_y=33
     ball_dy=2
     ball_r=2
     ball_dr=0.5
     frame=1
     col=11
     
     mode="start"
     lives=0
     complives=0
    end


function _update60()
if mode=="game" then
update_game()
elseif mode=="start" then
update_start()
elseif mode=="gameover" then
update_gameover()
elseif mode=="win" then
end

if complives==2 then
mode="gameover"
end

if lives==21 then
mode="win"
end
end

function update_start()
if btn(5) then
 startgame()
 end
end

function startgame()
mode="game"
end

function update_gameover()
cls(0)
end

   
function update_game()
local nextx,nexty
local padx, pady
if btn(0) then
pad_x -= 3
end
if btn(1) then
pad_x += 3
end

--move comp
if ball_y+2 > cpad_x+cpad_w then 
cpad_x+=9
elseif ball_y < cpad_x-cpad_w then
cpad_x-=9
end            
frame=frame+1
nextx=ball_x+ball_dx
nexty=ball_y+ball_dy
--keeps p1 pad on screen
pad_x=mid(0,pad_x,127-pad_w)
cpad_x=mid(0,cpad_x,127-cpad_w)

 --pulsate effect
 --w3erball_r = 2+sin(frame/10)
    
--if's
 -- pulsate if
if ball_r > 3 or ball_r < 2 then
   ball_dr = -ball_dr
end
 --collision detection
if nextx > 124 or nextx < 3 then
   nextx=mid(0, nextx, 127)
   ball_dx = -ball_dx
   sfx(1)
end

if nexty > 127 or nexty < 11 then
   nexty=mid(0, nexty, 127)
   ball_dy = -ball_dy
   sfx(1)
end

if ball_box(nextx,nexty,pad_x,pad_y,pad_w,pad_h) 
then 
     sfx(2)
   
if deflx_ballbox(ball_x,ball_y,ball_dx, ball_dy,pad_x,pad_y,pad_w,pad_h) then    
   ball_dx = -ball_dx
else
   ball_dy = -ball_dy
end
--   ball_dy = -ball_dy
end


-- this is the comp paddle
if ball_box(nextx,nexty,cpad_x,cpad_y,cpad_w,cpad_h) 
then 
     sfx(2)
if deflx_ballbox(ball_x,ball_y,ball_dx, ball_dy,cpad_x,cpad_y,cpad_w,cpad_h) then    
   ball_dx = -ball_dx
else
   ball_dy = -ball_dy
end
--   ball_dy = -ball_dy
end


ball_x=nextx
ball_y=nexty


if nexty > 126 then
 sfx(0)
 complives+=1
 serveball()
end

if nexty < 13 then
 sfx(0)
 lives+=1
 serveball()
end

function serveball()
     ball_x+=6
     ball_dx=2
     ball_y=33
     ball_dy=2
     ball_r=2
     ball_dr=0.5
end
    
--nextx=ball_x+ball_dx
--nexty=ball_y+ball_dy        
end

function _draw()
if mode=="game" then
draw_game()
elseif mode=="start" then
draw_start()
elseif mode=="gameover" then
draw_gameover()
elseif mode=="win" then
draw_gameover_win()
end
end

function draw_start()
cls()
--replace with sprite
print("paddlewar!", 40,40,11)
print("press ❎ to start",30,80,11)
print("created by waruj1m",25,120,11)
end

function draw_gameover()
--popup gameover
cls(5)
rect(15,45,110,70,11)
print("you lose!",45,50,11)
line(20,58,105,58,11)
print("press ❎ to continue",23,63,11)
if btn(5) then
 lives=0
 complives=0
 cls(5)
	startgame()
	end

end

function draw_gameover_win()
cls(5)
rect(15,45,110,70,11)
print("you win!!!",45,50,11)
line(20,57,105,57,11)
print("press ❎ to continue",23,60,11)
if btn(5) then
 lives=0
 complives=0
	startgame()
	end
end

function draw_game()
 cls(5)
 --draw computer paddle
 rectfill(cpad_x,cpad_y,cpad_x+cpad_w,cpad_y+cpad_h,pad_c)
 --draw ball
 circfill(ball_x,ball_y,ball_r,col)
 --draw player paddle
 rectfill(pad_x,pad_y,pad_x+pad_w,pad_y+pad_h,pad_c)
 --static stats etc
 print("keen:"..lives,3,0,11)
 print("picowar!",53,0,11)
 print("comp:"..complives,100,0,11)
 line(126,7,1,7,11) -- top line
 line(126,125,1,125,11) -- bottom line
 end
    
function ball_box(bx,by,box_x,box_y,box_w,box_h)
 -- checks for a collion of the ball with a rectangle
 if by-ball_r > box_y+box_h then return false end
 if by+ball_r < box_y then return false end
 if bx-ball_r > box_x+box_w then return false end
 if bx+ball_r < box_x then return false end
 return true
end    

function deflx_ballbox(bx,by,bdx,bdy,tx,ty,tw,th)
 -- calculate wether to deflect the ball
     -- horizontally or vertically when it hits a box
     if bdx == 0 then
      -- moving vertically
      return false
     elseif bdy == 0 then
      -- moving horizontally
      return true
     else
      -- moving diagonally
      -- calculate slope
      local slp = bdy / bdx
      local cx, cy
      -- check variants
      if slp > 0 and bdx > 0 then
       -- moving down right
       debug1="q1"
       cx = tx-bx
       cy = ty-by
       if cx<=0 then
        return false
       elseif cy/cx < slp then
        return true
       else
        return false
       end
      elseif slp < 0 and bdx > 0 then
       debug1="q2"
       -- moving up right
       cx = tx-bx
       cy = ty+th-by
       if cx<=0 then
        return false
       elseif cy/cx < slp then
        return false
       else
        return true
       end
      elseif slp > 0 and bdx < 0 then
       debug1="q3"
       -- moving left up
       cx = tx+tw-bx
       cy = ty+th-by
       if cx>=0 then
        return false
       elseif cy/cx > slp then
        return false
       else
        return true
       end
      else
       -- moving left down
       debug1="q4"
       cx = tx+tw-bx
       cy = ty-by
       if cx>=0 then
        return false
       elseif cy/cx < slp then
        return false
       else
        return true
       end
      end
     end
     return false
     end
__gfx__
000000000bbbb0000000000000000000000000000b0000b00000000b000000000000000000000000000000000000000000000000000000000000000000000000
000000000b00bb000000000000000000000000000b0000b00000000b000000000000000000000000000000000000000000000000000000000000000000000000
007007000b000bb00000000000000000000000000b0000b00000000b000000000000000000000000000000000000000000000000000000000000000000000000
000770000b0000bb0000000000000000000000000b0000b00000000b000000000000000000000000000000000000000000000000000000000000000000000000
000770000b0000bb0000000000000000000000000b0000b00000000b000000000000000000000000000000000000000000000000000000000000000000000000
007007000b000bb00000000000000000000000000b0000b00000000b000000000000000000000000000000000000000000000000000000000000000000000000
000000000b00bb000000000000000000000000000b0000b00000000b000000000000000000000000000000000000000000000000000000000000000000000000
000000000bbbb0000000000000000000000000000b0000b00000000b000000000000000000000000000000000000000000000000000000000000000000000000
000000000b000000000bb0000bbb0000b000bbbb0b0000b00bbb000b000000000000000000000000000000000000000000000000000000000000000000000000
000000000b00000000b00b000b00b000b000b0000b0000b00b00b00b000000000000000000000000000000000000000000000000000000000000000000000000
000000000b0000000b0000b00b000b00b000b0000b0000b00b000b0b000000000000000000000000000000000000000000000000000000000000000000000000
000000000b0000000b0000b00b000b00b000bbb00b0000b00b000b0b000000000000000000000000000000000000000000000000000000000000000000000000
000000000b0000000b0000b00b000b00b000b0000b0000b00b00b00b000000000000000000000000000000000000000000000000000000000000000000000000
000000000b0000000bbbbbb00b00b000b000b0000b0bb0b00bbb0000000000000000000000000000000000000000000000000000000000000000000000000000
000000000b0000000b0000b00b0b0000b000b0000bb00bb00b00b000000000000000000000000000000000000000000000000000000000000000000000000000
000000000b0000000b0000b00bb00000bbb0bbbb0b0000b00b000b0b000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
000200003b07034070300702c0702a070270702607025050230502305022050200501f0501d0401d0501b0501905018050160501405012050100500d0500a050120501805019050390503d0503c0503b0503f050
000100002335022350223502235004350043500635004350033500335003350000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
000100002635026350263502635026350263502635000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
