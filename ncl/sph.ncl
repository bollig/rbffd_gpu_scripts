;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; R. Nair IMAGe/NCAR  Midlat_Jet test (Galesky)                ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;

;load "gsn_code.ncl"
;;;;;;;;
; loads the required NCL commands used below (think importing packages in python)
;;;;;;;
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_code.ncl"
load "$NCARG_ROOT/lib/ncarg/nclscripts/csm/gsn_csm.ncl"

;
;  Main program
;
begin
 
; Scalar Values at the NODE POINTS
  fdat = "./ComputedSolution.dat"
; X-Coords of NODES
  xdat = "./grid.dat"
; Number of NODE COORDS per file 
  gdat = "./geometry.dat"

;Dimension of the data 
  gd = asciiread(gdat,(/2/),"integer")
  m = gd(0) 
  N = gd(1) 
  
;print(N)
;print(m)

  data = asciiread(fdat,(/N/),"float")

 ; Should read 10201,10201,10201 
  nodes = asciiread(xdat,(/N,3/),"float")

print(nodes(0,:))
print(data(0:5))



X = nodes(:,0); 
Y = nodes(:,1); 
Z = nodes(:,2);


;; Convert Cartesian Coords to Lat/Lon coords 
;rlat = new(N,float)
;rlon = new(N,float) 
;something =csc2s(N,X,Y,Z,rlat,rlon)
latlon = csc2s(X,Y,Z)

;
;  Create the triangulation.
;
nt = new(1, integer)
ntri=new(1,integer)
iwk=new(1,integer)
rkw=new(1,float)
ier=new(1,integer)

    ;triangles = csstri(N,rlat,rlon,nt,ntri,iwk,rwk,ier)
    triangles = csstri(latlon(0,:),latlon(1,:))
    tri_sizes = dimsizes(triangles)
    num_triangles = tri_sizes(0)

rlat = latlon(0,:)
rlon = latlon(1,:)

  ;NI =  73
  ;NJ = 145
  NI = 600
  NJ = 600 
;
;  Set up the latitudes and longitudes for the interpolated grid.
;
  platn = new(NI,float) 
  plonn = new(NJ,float) 
  do i=0,NI-1
    platn(i) = -90.+i*(180./NI) ; 2.5
  end do
  do j=0,NJ-1
    plonn(j) = -180.+j*(360./NJ) ; 2.5
  end do

;
;  Interpolate to the regular grid.
;
  ff = cssgrid(rlat,rlon,data,platn,plonn)





; print(tx(0,0,:))
; Create a workstation.
;
  NCGM=0
  X11=1
  PS=1
  PDF=0


  if (NCGM .eq. 1) then
   ;wks = gsn_open_wks("ncgm","tracer")
    wks = gsn_open_wks("png","tracer")
  end if
  if (X11 .eq. 1) then
    wks = gsn_open_wks("x11","tracer")
  end if
  if (PS .eq. 1) then
    wks = gsn_open_wks("eps","tst")
    ;wks = gsn_open_ps("ps","tracer")
  end if
  if (PDF .eq. 1) then
    wks = gsn_open_wks("pdf","tracer")
  end if

;
;  Define a color map.
;
; gsn_define_colormap(wks,"BlAqGrYeOrRe")
;  gsn_define_colormap(wks,"rainbow")
;  gsn_define_colormap(wks,"WhViBlGrYeOrReWh")
;  gsn_define_colormap(wks,"WhBlReWh")
 ; gsn_define_colormap(wks,cmap)
;  gsn_define_colormap(wks,"WhViBlGrYeOrRe")

  gsn_define_colormap(wks,"wh-bl-gr-ye-re")

; To make background color to white
;
    setvalues wks
   "wkBackgroundColor" : (/ 1.0,1.0,1.0 /)
    end setvalues
;
;  Define some resources and draw a globe as a background for 
;  the plot.
;
  map_resources = True
  map_resources@gsnFrame = False
; map_resources@gsnMaximize = True     ;;Full Frame

   map_resources@mpGridAndLimbOn = False 
   map_resources@mpGridSpacingF = 30.0
   map_resources@mpGridLineDashPattern = 2
   map_resources@mpLimbLineColor = 1
   map_resources@mpGridLineColor = 0
   map_resources@mpGreatCircleLinesOn = True
   map_resources@mpPerimLineThicknessF   = 1.


;  map_resources@wkBackgroundColor = 1

   map_resources@mpProjection = "Orthographic" ; Change the map projection.
   map_resources@mpCenterLonF =  180. + 90.           ; Rotate the projection.
   map_resources@mpCenterLatF =  0.0           ; Rotate the projection.
   map_resources@mpOutlineOn     = False       ; Show continents

;;;
; DISABLE THE MAP: 
;;;
  map_resources@mpFillOn     = False        ; Color the continents .
 ; resources@mpFillColors = (/0,-1,28,-1/) ; Fill land and leave oceans
                                          ; and inland water transparent.

  map_resources@vpXF      = 0.1    ; Change the size and location of the
  map_resources@vpYF      = 0.92   ; plot on the viewport.
  map_resources@vpWidthF  = 0.8
  map_resources@vpHeightF = 0.8

; map_resources@mpMinLatF = 0.0
; map_resources@mpMaxLatF = 90.0

;; EVAN
;; THESE CONTROL THE DATA COLORMAP RANGE
;;
  mnlvl = 0.0                 ; Minimum contour level.
  mxlvl = 1.0               ; Maximum contour level.
  spcng = 0.1                   ; Contour level spacing.
  ncn   = (mxlvl-mnlvl)/spcng + 1  ; Number of contour levels.

;
; Contour line features
;

  map_resources@cnLevelSelectionMode = "ManualLevels" ; Define your own
  map_resources@cnMinLevelValF       = mnlvl          ; contour levels.
  map_resources@cnMaxLevelValF       = mxlvl
  map_resources@cnLevelSpacingF      = spcng

  map_resources@cnInfoLabelOn        = False    ; Print summary of contour range as label
  map_resources@cnLineLabelsOn       = False    ;No cotour labels 
  map_resources@cnInfoLabelPerimOn   = False

   map_resources@cnFillOn        = True               ; color plot desired
   map_resources@gsnSpreadColors = True               ; use full color table
   map_resources@gsnSpreadColorStart = 0
   map_resources@gsnSpreadColorEnd   = -1       ; use ALL colors (specify number of colors to use here) 


   map_resources@pmLabelBarDisplayMode   = "Always"
   map_resources@pmLabelBarSide          = "Bottom"
   map_resources@lbOrientation           =  "horizontal"
   map_resources@lbPerimOn               =  False
   map_resources@pmLabelBarParallelPosF   =  .5         ; CENTER the label
   map_resources@pmLabelBarOrthogonalPosF =  .0
   map_resources@pmLabelBarWidthF  =  .525
   map_resources@pmLabelBarHeightF   =  .095

   map_resources@lbLabelStride       = 2       ;
   map_resources@lbTitleFontThicknessF   = .06
   map_resources@lbAutoManage = True 
   map_resources@lbLabelFontHeightF    = .0175
  map_resources@lbLabelAlignment = "InteriorEdges"

   map_resources@pmTickMarkDisplayMode = "Always"
   map_resources@cnLabelBarEndStyle = "IncludeMinMaxLabels"

  map_resources@cnLinesOn         = True             ; turn off contour lines
  map_resources@cnLineDashPattern    = 0     ; Solid line contours     
  map_resources@cnLineThicknessF     = 0.5   ; Double the line thickness.
  map_resources@cnMonoLineColor      = True   ;; COLOR or GRAYSCALE
  map_resources@cnLineColors         = 1 

  map_resources@cnLevelFlag       = True
  map_resources@cnFillOn          = True
; map_resources@cnFillDrawOrder   = PostDraw 
; map_resources@cnMonoFillPattern  = False
; map_resources@cnFillcolor  = False
; map_resources@cnFillPattern      = True


;
;  Mark the original data points with black circles.
;
  map = gsn_map(wks,"Satellite",map_resources)

  gsres = True
  gsres@gsLineColor = 1
  arclat = new(N, float)
  arclon = new(N, float)
  do i=0, N-1
    do j=1,1
    ; Fills the circles by computing 6 concentric rings
;      nggcog(rlat(i),rlon(i),0.15*j,arclat,arclon)
      ; Draws the concentric rings
;      gsn_polyline(wks,map,arclon,arclat,gsres)
    end do
  end do


;
; Sticking the cotour plots on the map
;
;; EVAN: plug coords here: 
;  map_resources@sfXArray              = rlat; X axes data points
;  map_resources@sfYArray              = rlon; Y axes data points

   map_resources@sfXCStartV = -180.0         ; Define where contour plot
   map_resources@sfXCEndV   = 180.0         ; should lie on the map plot.
;  map_resources@sfXCStartV = -90.0         ; Define where contour plot
;  map_resources@sfXCEndV   = 270.0         ; should lie on the map plot.
   map_resources@sfYCStartV = -90.0
   map_resources@sfYCEndV   =  90.0

print("Here\n\n\n1")

;; EVAN: PLOT HERE:
   map = gsn_contour_map(wks,ff,map_resources) ; Draw contours over a map.
;  map = gsn_csm_contour_map_ce(wks,ff,map_resources) ; Draw contours over a map.


;
;  Cubed-sphere features 
;
;   gsres = True
;   gsres@gsLineThicknessF = 2.

;;; 
; Line Color 1 shows cubed sphere. Line Color 0 does not show anything
;;;
;   gsres@gsLineColor = 0
;
;   do l=0,3 
;    do j=0,k-1,k-1
 ;    aa(:) = tx(l,j,:)
;     bb(:) = ty(l,j,:)
;      ; if ( j.eq.(k-1)) then
;      ; gsres@gsLineColor = 4
;      ; end if 
;     gsn_polyline(wks,map,aa,bb,gsres)
;    end do
;
;    do j=0,k-1,k-1
;    aa(:) = tx(l,:,j)
;     bb(:) = ty(l,:,j)
;     gsn_polyline(wks,map,aa,bb,gsres)
;    end do
;   end do

print("Here\n\n\n")
;
;  Legend
;
; txres = True
; txres@txFontHeightF = 0.025
; txres@txFontColor = 1
; txres@txJust = "CenterLeft"
; draw_box(wks, 0.02, 0.945, 0.12, 0.955, 2, gsres)
; gsn_text_ndc(wks, ":F22:Delaunay triangles", 0.14, 0.95, txres)
; draw_box(wks, 0.02, 0.895, 0.12, 0.905, 3, gsres)
; gsn_text_ndc(wks, ":F22:Voronoi polygons", 0.14, 0.90, txres)
; draw_box(wks, 0.02, 0.845, 0.12, 0.855, 4, gsres)
; gsn_text_ndc(wks, ":F22:Circumcircles", 0.14, 0.85, txres)

;
;  Title
;
  txres = True
  txres@txFontHeightF = 0.025
  txres@txFontColor = 1
  txres@txJust = "CenterCenter"
  gsn_text_ndc(wks, "DGP2: Sph Transport", 0.5, 0.95, txres)


  frame(wks)

end


