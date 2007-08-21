PRO MTA_PLOT_XMM_TLE,XMIN,XMAX,PLOTX=plotx
; plot xmm ephemeris
; specify exact bounds of x axis (in days since 1/1/1998) to match
;  xmm_rad plot
; 21.jul2004 bds

tlefile="/proj/rac/ops/ephem/TLE/xmm.spctrk"
readcol,tlefile,sec,yy,dd,hh,mm,ss,x_eci,y_eci,z_eci,vx,vy,vz, $
  format='L,I,I,I,I,I,F,F,F,F,F,F',skipline=5
sec=sec-8.83613e+08-86400.0
time=(sec/60./60./24.)-2190.0-366.0-365.-365. ; 2007 days

nel=n_elements(sec)
es=lonarr(nel)
x_gsm=fltarr(nel)
y_gsm=fltarr(nel)
z_gsm=fltarr(nel)
mon_days=[31,28,31,30,31,30,31,31,30,31,30,31]
openw,tunit,"xdate",/get_lun ;debug
openw,cunit,"xcoords",/get_lun ;debug
for i=0,n_elements(sec)-1 do begin
  mon_days=[31,28,31,30,31,30,31,31,30,31,30,31]
  leap=2000
  while (yy(i) ge leap) do begin
    if (yy(i) eq leap) then mon_days(1)=29
    leap=leap+4
  endwhile ; while (yy(i) ge leap) do begin
  mon=1
  day=dd(i)
  while (day gt mon_days(mon-1)) do begin
    day=day-mon_days(mon-1)
    mon=mon+1
  endwhile ;while (day gt mon_days(mon-1)) do begin
  printf,tunit,yy(i),dd(i),mon,day ;debug
  ;es(i)=date2es(mon,day,yy(i),hh(i),mm(i),ss(i))
  ;gsm=cxform([x_eci(i),y_eci(i),z_eci(i)],'GEI','GSM',es(i))
  ;x_gsm(i)=gsm(0)
  ;y_gsm(i)=gsm(1)
  ;z_gsm(i)=gsm(2)

  ;printf,tunit,yy(i),dd(i),mon,day,es(i) ;debug
  ;printf,cunit,"ECI ",x_eci(i),y_eci(i),z_eci(i)  ;debug
  ;printf,cunit,"GSM ",x_gsm(i),y_gsm(i),z_gsm(i)  ;debug
  
endfor ;for i=0,n_elements(sec)-1 do begin
free_lun,tunit ;debug
free_lun,cunit ;debug

;xwidth=640
;yheight=220
;if (keyword_set(plotx)) then begin
;  set_plot,'x'
;  window,0,xsize=xwidth,ysize=yheight
;endif else begin
;  set_plot,'z'
;  device,set_resolution = [xwidth,yheight]
;endelse ;

r_eci=sqrt(x_eci^2+y_eci^2+z_eci^2)/1000.0
;r_gsm=sqrt(x_gsm^2+y_gsm^2+z_gsm^2)

;set colors
loadct,39
back_color=0     ; black
grid_color=255   ; white
dblue=50     ; dark blue
lblue=100    ; light blue
red=230     ;red
orange=215     ; orange
yellow=190    ; yellow
green=150    ; green
csize=2.0
chancsize=0.7    ; char size for channel labels

;!p.multi=[0,1,1,0,0]

xleft=15 ;set xmargin
xright=1

; figure out time ranges and labels
;xmin=min(time)
;xmax=max(time)
t_arch=fix(xmax-xmin)
;print,xmin,xmax
doyticks=indgen(t_arch)+floor(min(xmin))
nticks=n_elements(doyticks)
xticklab=strcompress(string(doyticks+1),/remove_all)

ymin=min(r_eci)
ymax=max(r_eci)
;print,time(0),r_eci(0),sec(0) ; debug
plot,time,r_eci,background=back_color,color=grid_color, $
  xstyle=1,ystyle=1,xrange=[xmin,xmax],yrange=[ymin,ymax],/nodata, $
  charsize=csize,ymargin=[-12,18], xmargin=[xleft,xright], $
  xticks=nticks-1,xtickv=doyticks, ytitle="Altitude (kkm)", $
  xtickname=xticklab,xminor=12, $
  ;xtitle="DOY (2004)"
  xtitle=""
oplot,time,r_eci,color=lblue
;oplot,time,r_gsm,color=red

;write_gif,'/data/mta4/www/RADIATION/XMM/mta_xmm_plot_tle.gif',tvrd()

end
