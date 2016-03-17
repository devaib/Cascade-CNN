--require 'xlua'
require 'torch'
require 'nn'
require 'nnx'
--require 'qt'
require 'qtwidget'
require 'qtuiloader'
--require 'cunn'
--require 'inn'
require 'image'

-- Local files

require 'PyramidPacker'
require 'PyramidUnPacker'

--norm_data = torch.load('../12net/results/norm.dat')
net12_path = '../12net/model.net'
calib12_path = '../12cnet/model.net'

--[[calib12_path = '../12calibnet/results/1model.net'
net24_path = '../24net/results/3model.net'
calib24_path = '../24calibnet/results/1model.net'
net48_path = '../48net/results/1model.net'
--calib48_path = '../48calibnet/results/model.net'
]]--

ich = 1
imgcnt = 1

network_fov = {12,12}
network_sub = 2

FilterSize1 = {12,12}
FilterSize2 = {24,24}
FilterSize3 = {48,48}

nmsth1 = .1
nmsth2 = .75
gnmsth = .75

useNMS = 0 --un 
useGNMS = 1
si=.99;
--[[
min_size = 30
s = FilterSize1[1]/min_size
Nscales = 8
scratio = math.sqrt(2)
scales = {}
for k=1,Nscales do
    scales[k] = s*(1/scratio)^(Nscales-k)
end
]]--
scales = {1}


-- display function
function display()
    zoom = 1
    win:gbegin()
    win:showpage()
    image.display{image=frame, win=win, zoom=zoom}
    if widget.s1.checked then
        s1 = 1
    else
        s1 = 0
    end
    if widget.s2.checked then
        s2 = 1
    else
        s2 = 0
    end
    if widget.s3.checked then
        s3 = 1
    else
        s3 = 0
    end
    if s1==1 then
        if(detections1view~=nil) then
            win:setcolor(0,0,1)
            win:setlinewidth(1)  
            for i=1,detections1view:size(1) do
                detect=detections1view[i]:narrow(1,1,5)
                win:rectangle(detect[1], detect[2], detect[3]-detect[1], detect[4]-detect[2])
                win:stroke()
                win:setfont(qt.QFont{serif=false,italic=false,size=16})
                win:moveto(detect[1], detect[2]-1)
                win:show(string.format("%1.2f",detect[5]))
            end
        end
    end
    if s2==1 then
        if(detections2~=nil) then
            win:setcolor(1,0,0)
            win:setlinewidth(1)
            for i=1,detections2:size(1) do
                detect=detections2[i]
                win:rectangle(detect[1], detect[2], detect[3]-detect[1], detect[4]-detect[2])
                win:stroke()
                win:setfont(qt.QFont{serif=false,italic=false,size=16})
                win:moveto(detect[1], detect[2]-1)
                win:show(string.format("%1.2f",detect[5]))
            end
        end
    end
    if s3==1 then
        if(detections3~=nil) then
            win:setcolor(0,1,0)
            win:setlinewidth(2)
            for i=1,detections3:size(1) do
                detect=detections3[i]
                win:rectangle(detect[1], detect[2], detect[3]-detect[1], detect[4]-detect[2])
                win:stroke()
                win:setfont(qt.QFont{serif=false,italic=false,size=16})
                win:moveto(detect[1], detect[2]-1)
                win:show(string.format("%1.2f",detect[5]))
            end
        end
    end
--    for i=1,#t do
--        win:setcolor(1,0,0)
--        win:rectangle(t[i][2]*network_sub, t[i][1]*network_sub, 64, 64)
--        win:stroke()
--        win:setfont(qt.QFont{serif=false,italic=false,size=16})
--        win:moveto(detect.x, detect.y-1)
--        win:show('face')
--    end
    win:gend()
    detections1view = nil
    detections2 = nil
    detections3 = nil   
end



function gnms(boxes, overlap)
    local pick = torch.LongTensor()

    if boxes:numel() == 0 then
        return pick
    end

    local x1 = boxes[{{},1}]
    local y1 = boxes[{{},2}]
    local x2 = boxes[{{},3}]
    local y2 = boxes[{{},4}]
    local s = boxes[{{},5}]
  
    local area = boxes.new():resizeAs(s):zero()
    area:map2(x2,x1,function(xx,xx2,xx1) return xx2-xx1+1 end)
    area:map2(y2,y1,function(xx,xx2,xx1) return xx*(xx2-xx1+1) end)

    local vals, I = s:sort(1)

    pick:resize(s:size()):zero()
    local counter = 1
    local xx1 = boxes.new()
    local yy1 = boxes.new()
    local xx2 = boxes.new()
    local yy2 = boxes.new()

    local w = boxes.new()
    local h = boxes.new()

    while I:numel()>0 do 
        local last = I:size(1)
        local i = I[last]
        pick[counter] = i
        counter = counter + 1
        if last == 1 then
            break
        end
        I = I[{{1,last-1}}]
        
        xx1:index(x1,1,I)
        xx1:clamp(x1[i],x2[i])
        yy1:index(y1,1,I)
        yy1:clamp(y1[i],y2[i])
        xx2:index(x2,1,I)
        xx2:clamp(x1[i],x2[i])
        yy2:index(y2,1,I)
        yy2:clamp(y1[i],y2[i])
        
        w:resizeAs(xx2):zero()
        w:map2(xx2,xx1,function(xx,xxx2,xxx1) return math.max(xxx2-xxx1+1,0) end)
        h:resizeAs(yy2):zero()
        h:map2(yy2,yy1,function(xx,yyy2,yyy1) return math.max(yyy2-yyy1+1,0) end)
        
        local inter = w
        inter:cmul(h)
        local o = h
        xx1:index(area,1,I)
        torch.cdiv(o,inter,xx1+area[i]-inter)
        I = I[o:le(overlap)]
    end

    pick = pick[{{1,counter-1}}]
    return pick
end

--============================================NMS===========================
function nms(boxes, overlap)
  local Mask=torch.ByteTensor()
  local Dets = boxes[{{},{1,4}}]:clone()
  local s = boxes[{{},5}]:clone()
  local s, i = torch.sort(s,1,true)
  local N=Dets:size(1)
  for k=1,N do 
    Dets[k]=boxes[{i[k],{1,4}}]
  end
  Ivec=nil
  boxes=nil
  local Dtmp=torch.Tensor()
  local cnt=0
  i=torch.range(1,N,1):type('torch.LongTensor')
  while N>1 do
    cnt=cnt+1
    local IOU,IOUgt0=IoU(Dets[{cnt,{}}],Dets[{{cnt+1,-1},{}}])
    Mask=torch.ByteTensor(Dets[{{cnt+1,-1},{}}]:size(1)):fill(1)
    Mask[IOUgt0]=IOU[IOUgt0]:le(overlap)
    N=torch.sum(Mask)
    if N==0 then
      s=s[{{1,cnt}}]
      i=i[{{1,cnt}}]
      N=0
      Dets=Dets[{{1,cnt},{}}]
    else
      s=torch.cat(s[{{1,cnt}}],s[{{cnt+1,-1}}][Mask],1)
      i=torch.cat(i[{{1,cnt}}],i[{{cnt+1,-1}}][Mask],1)
      Mask=torch.repeatTensor(Mask,4,1):t()
      Dets=torch.cat(Dets[{{1,cnt},{}}],Dets[{{cnt+1,-1},{}}][Mask]:resize(N,4),1)
    end
  end
  return torch.cat(Dets,s,2),Dets:size(1)
end
--==END NMS==--
--IoU--====================
function IoU(d,D)
  local N=D:size(1)
  local InoU=torch.Tensor(N):fill(0) --intersection for now
  local O=torch.Tensor(N):fill(0) --overlap
  local logica=D[{{},3}]:lt(d[1]) --x2'<x1
  local logicb=D[{{},1}]:gt(d[3]) --x1'<x2
  local Xfit=(logica+logicb):ge(1)  --logic OR. if X fits, Xfit=1 else Xfit=0
  logica=nil
  logicb=nil
  local logicc=D[{{},4}]:lt(d[2]) --y2'<y1
  local logicd=D[{{},2}]:gt(d[4]) --y1'<y2
  local Yfit=(logicc+logicd):ge(1)  --logic OR. if Y fits, Yfit=1 else Yfit=0
  logicc=nil
  logicd=nil
  local XYfit=Xfit:eq(Yfit)  --XYfit =(Xfit AND Yfit)
  --compute intersectionarea
  InoU[XYfit]=torch.cmul(torch.clamp(D[{{},3}][XYfit],d[1],d[3])-torch.clamp(D[{{},1}][XYfit],d[1],d[3])+1,torch.clamp(D[{{},4}][XYfit],d[2],d[4])-torch.clamp(D[{{},2}][XYfit],d[2],d[4])+1) 
  --compute overlap
  O[XYfit]=torch.cmul(D[{{},3}][XYfit]-D[{{},1}][XYfit]+1,D[{{},4}][XYfit]-D[{{},2}][XYfit]+1)+math.pow(d[3]-d[1]+1,2)-InoU[XYfit] --compute only overlaps for non-zero intersections
  InoU[XYfit]=torch.cdiv(InoU[XYfit],O[XYfit])
  return InoU, XYfit
end

--END_IoU=======================-


function applyCalibNetCropped(model,iims,detections,o,isize,threshold,un,unT,g)
    if(detections~=nil) then   
        local ca = torch.exp(model:forward(iims:float()))
       
        local trans = torch.Tensor(ca:size(1),3):zero()
        if average==1 then
            trans:addmm(ca,T)
        else
            for i=1,ca:size(1) do
                c = 0
                for j=1,ca:size(2) do
                    if(ca[i][j] > threshold) then
                        trans[i] = trans[i] + T[j]
                        c = c + 1
                    end
                end
                if(c ~= 0) then
                    trans[i][1] = trans[i][1]/c
                    trans[i][2] = trans[i][2]/c
                    trans[i][3] = trans[i][3]/c
                else
                    trans[i][1] = 1
                    trans[i][2] = 0
                    trans[i][3] = 0
                end
            end
        end
       
        local detectionsR = detections
        for i=1,detections:size(1) do
            --print(detections2[i][1]..' '..detections2[i][2]..' '..detections2[i][3]..' '.. detections2[i][4]..' '..im:size(2)..' '..im:size(3))
            w = detections[i][3]-detections[i][1]
            h = detections[i][4]-detections[i][2]
            sn = trans[i][1]
            xn = trans[i][2]
            yn = trans[i][3]
    
            --print(xn..' '..yn..' '..sn)
            x1 = torch.round(detections[i][1] - xn*w/sn)
            y1 = torch.round(detections[i][2] - yn*h/sn)
            x2 = torch.round(x1 + w/sn)
            y2 = torch.round(y1 + h/sn)
            
            detectionsR[i][1] = x1
            detectionsR[i][2] = y1
            detectionsR[i][3] = x2
            detectionsR[i][4] = y2
            detectionsR[i][5] = o[i][1]
            --print('edited '..detections2[i][1]..' '..detections2[i][2]..' '..detections2[i][3]..' '.. detections2[i][4]..' '..im:size(2)..' '..im:size(3))
        end
        if(un==1) then
            if(g==0) then
                nmsKeep = nms(detectionsR,unT,0.02)
            else
                nmsKeep = gnms(detectionsR,unT)
            end
        else
            nmsKeep = torch.LongTensor(detectionsR:size(1))
            for j=1,nmsKeep:size(1) do
                nmsKeep[j] = j
            end
        end
        
        local detectionsR1 = torch.Tensor()
        detectionsR1:index(detectionsR,1,nmsKeep)
        nmsKeep = nil
        return detectionsR1
    else 
        return nil
    end
end



function cropImage(iarg, iim, isize)
    -- This function crops an image(CxHxW) with input arguments (x1,y1,x2,y2) from matrix coordinates (x=j,y=i). (start at (i,j)=(1,1))
    -- The processing is done in matrix coordinates (i,j).
    local img_width = iim:size(3)
    local img_hight = iim:size(2)

    local oim = torch.Tensor(ich, iarg.y2-iarg.y1+1, iarg.x2-iarg.x1+1):fill(0)
    local Mask = torch.ByteTensor(ich, iarg.y2-iarg.y1+1, iarg.x2-iarg.x1+1):fill(0)
    local iIx2 = math.min(iarg.x2, img_width)
    local iIx1 = math.max(iarg.x1, 1)  -- 1 because start index of image=1
    local DiIx = iIx2 - iIx1 + 1  -- span of elements in x copyied from input image to output image
    local Offsx = iIx1 - math.min(iarg.x1, iIx1) -- index offset of output image in x

    local iIy2 = math.min(iarg.y2, img_hight)
    local iIy1 = math.max(iarg.y1, 1)  -- 1 because start index of image=1
    local DiIy = iIy2 - iIy1 + 1  -- span of elements in y copyied from input image to output image
    local Offsy = iIy1 - math.min(iarg.y1, iIy1) -- index offset of output image in y

    local Ic = iim:sub(1, -1, iIy1, iIy2, iIx1, iIx2):clone()

    Mask:sub(1, -1, Offsy+1, Offsy+DiIy, Offsx+1, Offsx+DiIx):fill(1)

    oim:maskedCopy(Mask, Ic)

    oim = image.scale(oim, isize[1], isize[2])
    return oim          
end



function applyNet(model, iimage, detections, isize, threshold)
    if(detections ~= nil) then
        local iimVec = torch.Tensor(detections:size(1),ich,isize[2],isize[1])
        for i=1,detections:size(1) do
            detect = detections[i]
            iimVec[i] = cropImage({x1 = detect[1], y1 = detect[2], x2 = detect[3], y2 = detect[4]}, iimage, isize)
        end
        o = torch.exp(model:forward(iimVec:float())):double()
        local cnt = 1
        k = torch.LongTensor(o:size(1))
        for i=1,o:size(1) do
            a = o[i][1]
            --b = out2[i][2]
            if (a > threshold) then
                k[cnt] = i
                cnt = cnt + 1
            end  
        end
        if(cnt>1) then
            k = k[{{1,cnt-1}}]
            local o1 = torch.Tensor()
            o1:index(o,1,k)
            local iimVec1 = torch.Tensor()
            iimVec1:index(iimVec,1,k)
            local detectionsR = torch.Tensor()
            detectionsR:index(detections,1,k)
            return detectionsR,o1,iimVec1
        else
            return nil,nil,nil
        end
    else
        return nil,nil,nil
    end
end

--  detections1 = applyCalibNet(calib12,im,detections1,FilterSize1,threshold12Calib)
function applyCalibNet(model,iim,detections,isize,threshold)
    --print('************** original: ', iim)
    --print('**************end')

    if(detections~=nil) then
        local iimVec = torch.Tensor(detections:size(1),ich,isize[2],isize[1])
        for i=1,detections:size(1) do
            detect=detections[i]
            --iimVec[i] = cropImage({x1 = detect[1], y1 = detect[2], x2 = detect[3], y2 = detect[4]}, iim, isize)
            print('method 0    : ', detect[2], detect[4], detect[1], detect[3])
            print('method 111  : ', detect[2], detect[4]-1, detect[1], detect[3]-1)
            print('method 22222: ', detect[2]+1, detect[4], detect[1]+1, detect[3])
            iimVec[i] = iim[{1, {detect[2]+1, detect[4]}, {detect[1]+1, detect[3]}}]
            
            --print(detect[1], detect[2], detect[3], detect[4])
            --print('*********',i, iimVec[i])
        end
--        image.display(iimVec[1])
        --print('*********', iimVec[1])
        local segment = iim[{1,{19, 30},{59, 70}}]
        ---print('%%%%%%%%%%', segment)


        --image.display{image=im2, nrow=32}
        local ca1 = torch.exp(model:forward(iimVec:float()))  -- ca1_(#det x 45 )
        --print(detections)
        --print('$$$$$$$$$$$$$$$$', ca1)
        local trans = torch.Tensor(ca1:size(1),3):zero()
        
local net = nn.Sequential()
net:add(model.modules[1])
y = net:forward(iimVec[1]:float())
--print('===================== =================== ===============',y)
--print('===================== =================== ===============', iimVec[1])
        

        if average==1 then
            trans:addmm(ca1,T)
        else
            for i=1,ca1:size(1) do-- for each detection window 
                c = 0
                local maxlbl=torch.max(ca1[i])
                for j=1,ca1:size(2) do -- for all 45 labels
                    if(ca1[i][j] > threshold) then
                        trans[i] = trans[i] + T[j]
                        c = c + 1
                    end
                end
                if (c~=0) then
                    trans[i][1] = trans[i][1]/c
                    trans[i][2] = trans[i][2]/c
                    trans[i][3] = trans[i][3]/c
                elseif (c == 0) then
                    for j=1,ca1:size(2) do
                        if(ca1[i][j] == maxlbl) then
                            trans[i] = trans[i] + T[j]
                            c = c + 1
                        end
                    end
                    trans[i][1] = trans[i][1]/c
                    trans[i][2] = trans[i][2]/c
                    trans[i][3] = trans[i][3]/c
                end
            end
        end
   
   
        for i=1,trans:size(1) do 
            w = math.abs(detections[i][3]-detections[i][1])--w = detections[i][3]-detections[i][1]
            h = math.abs(detections[i][4]-detections[i][2])--h = detections[i][4]-detections[i][2]
            sn = trans[i][1]
            xn = trans[i][2]
            yn = trans[i][3]
            x1 = torch.round(detections[i][1] -w*xn+(sn-1)*w/2/sn)
            y1 = torch.round(detections[i][2] -w*yn+(sn-1)*h/2/sn)
            x2 = torch.round(detections[i][1] -w*xn+(sn-1)*w/2/sn+w/sn)
            y2 = torch.round(detections[i][2] -w*yn+(sn-1)*h/2/sn+h/sn)
           detections[i][1] = x1
           detections[i][2] = y1
           detections[i][3] = x2
           detections[i][4] = y2 
        end
    end
    return detections
end



function parseFFI(pin, threshold, blobs, scale)
    --loop over pixels
    for y=1, pin:size(2) do
        for x=1, pin:size(3) do
            a = math.exp(pin[1][y][x])
            if (a > threshold) then
                entry = {}
                entry[1] = x-1
                entry[2] = y-1
                entry[3] = scale
                entry[4] = a
                table.insert(blobs,entry)
            end
        end
    end
end



-- process function
function process()
    -- grab frame
    frame = image.load(t[imgcnt])
    print(t[imgcnt])
    -- process input at multiple scales
    im = image.rgb2y(frame)   --:float()
    -- Normalise mean and variance for each channel
--[[    for i=1,ich do
        im[{i, {}, {}}]:add(-norm_data[1][i])
        im[{i, {}, {}}]:div(norm_data[2][i])
    end
]]--
    local imean = im:mean()
    local istd = im:std()
    im:add(-imean)
    im:div(istd)
    im = image.scale(im, 75, 50)
--print(im)


    --print(im:type())
    pyramid, coordinates, nScales = packer:forward(im)    -- Why does this have to be a double when it is not in the other script
    tt = torch.Timer() 
--    print(pyramid)

    det = net12:forward(pyramid:float())
    tt:stop()
--    print('det')
--    print(torch.exp(det[{1,{},{}}]))

    distributions = unpacker:forward(det, coordinates)
    threshold12 = 0.5 --widget.t1.value/10000
    threshold24 = widget.t2.value/10000  
    threshold48 = widget.t3.value/10000
    threshold12Calib = 0.1 --widget.t4.value/20000
    threshold24Calib = widget.t5.value/20000

--for i = 1,#distributions do
--print(torch.exp(distributions[1][{1,{},{}}]))
--end
   
    if widget.av.checked then
        average = 1
    else
        average = 0
    end
   
    if widget.nms.checked then
        useNMS = 1
    else
        useNMS = 0
    end
   
    if widget.gnms.checked then
        useGNMS = 1
    else
        useGNMS = 0
    end
   
    print('threshold12 = '..threshold12..' threshold24 = '..threshold24..' threshold48 = '..threshold48..' threshold12Calib = '..threshold12Calib..' threshold24Calib = '..threshold24Calib)
    rawresults = {}
    -- function FFI:
    for i,distribution in ipairs(distributions) do
        parseFFI(distribution, threshold12, rawresults, nScales[i])
    end
    if(#rawresults <1) then
        return    
    end
    -- (7) clean up results
    detections1 = torch.Tensor(#rawresults,5)
    counter = 0
    for i,res in ipairs(rawresults) do
        local scale = res[3]
        local x = torch.round(res[1]*network_sub/scale)
        local y = torch.round(res[2]*network_sub/scale)
        local w = torch.round(network_fov[1]/scale)
        local h = torch.round(network_fov[2]/scale)
        detections1[{i,1}] = x
        detections1[{i,2}] = y
        detections1[{i,3}] = x+w
        detections1[{i,4}] = y+h
        detections1[{i,5}] = res[4]
		counter = counter + 1
	--if counter < 62 then
		print(counter-1,x, y, w, h,': ', res[4])
	-- end
    end
--	print(detections1)

    --print(torch.exp(net12:forward(im[{{},{1,12},{5,16}}]:float()))[1][1][1])
    --print(torch.exp(net12:forward(im[{{},{1,12},{3,14}}]:float()))[1][1][1])
    print("net12 done")
    
    --================Calibration 12 Net===================
--[[
    if(useNMS==1) then
        detections1 = nms(detections1,nmsth1)
--    else
--        keep1nms = torch.LongTensor(detections1:size(1))
--        for j=1,keep1nms:size(1) do
--            keep1nms[j] = j
--        end
    end
    ]]
    
    detections1 = nms(detections1,nmsth1)
	
    detections1 = applyCalibNet(calib12,im,detections1,FilterSize1,threshold12Calib)
    print(detections1)

--    local ndetections1 = torch.Tensor()
--    ndetections1:index(detections1,1,keep1nms)
--    detections1 = ndetections1
--    ndetections1 = nil

    print("net12-calib done")

	detections1view = detections1:clone()
	detections1view[{{},{1,4}}] = detections1[{{},{1,4}}] * 6

    --======================24 Net=========================
--    detectionsT,out2,imVec = applyNet(net24,im,detections1,FilterSize2,threshold24)
--    detections2,out2,imVec = applyNet(net24,im,detections1,FilterSize2,threshold24)
--    print("net24 done")

    --================Calibration 24 Net===================
--    detections2 = applyCalibNetCropped(calib24,imVec,detectionsT,out2,FilterSize2,threshold24Calib,useNMS,nmsth2,0,si)
--    print("net24-calib done")
    --print(keep2nms:size(1))

    --====================48 Filter========================  
--    detectionsT,out3,imVec = applyNet(net48,im,detections2,FilterSize3,threshold48)
--    print("net48 done")
--[[
    if(useGNMS==1) then
        keep1nms = gnms(detectionsT,gnmsth)
    else
        keep1nms = torch.LongTensor(detectionsT:size(1))
        for j=1,keep1nms:size(1) do
            keep1nms[j] = j
        end
    end
    local ndetectionsT = torch.Tensor()
    ndetectionsT:index(detectionsT,1,keep1nms)
    detectionsT = ndetectionsT
    ndetectionsT = nil
    local nout3 = torch.Tensor()
    nout3:index(out3,1,keep1nms)
    out3 = nout3
    nout3 = nil
    local nimVec = torch.Tensor()
    nimVec:index(imVec,1,keep1nms)
    imVec = nimVec
    nimVec = nil
    print('gnms done')
]]--
    --================Calibration 48 Net===================
--    detections3 = applyCalibNetCropped(calib48,imVec,detectionsT,out3,FilterSize3,threshold48Calib,0,gnmsth,1,si)
--    detections3 = detectionsT
--    print("net48-calib done")
end



function loadDataFiles(dir)
    local t,i,popen = {},1,io.popen
    for filename in popen('ls -A "'..dir..'"' ):lines() do
        t[i] = dir..filename
        i=i+1
    end
    return t
end



t = loadDataFiles('images/')

network_temp = torch.load(net12_path)
print(network_temp)
net12 = nn.Sequential()
for i=1,7 do
    net12:add(network_temp.modules[i])
end
classifier1 = nn.Sequential()
for i=8,10 do 
    classifier1:add(network_temp.modules[i])
end
classifier = nn.SpatialClassifier(classifier1)
net12:add(classifier)
net12:evaluate()
net12.modules[8].modules[1]:evaluate()
net12:float()
print(net12)
print(classifier1)

calib12 = torch.load(calib12_path)
calib12:float()
print(calib12)

--net24 = torch.load(net24_path)
--net24:float()

--calib24 = torch.load(calib24_path)
--calib24:float()

--net48 = torch.load(net48_path)
--print(net48)
--net48.modules[4]:evaluate()
--net48.modules[8]:evaluate()
--net48:float()

--calib48 = torch.load(calib48_path)
--calib48:float()

local s = {0.83,0.91,1.0,1.10,1.21}
local xy = {-0.17,0,0.17}
T = torch.Tensor(45,3)
local cnt = 0
for i=1,5 do
    for j=1,3 do
        for k=1,3 do
            cnt=cnt+1
            T[cnt][1] = s[i]
            T[cnt][2] = xy[j]
            T[cnt][3] = xy[k]
        end
    end
end

-- use a pyramid packer/unpacker
packer = nn.PyramidPacker(net12, scales)
unpacker = nn.PyramidUnPacker(net12)

-- setup GUI (external UI file)
widget = qtuiloader.load('g.ui')
win = qt.QtLuaPainter(widget.frame)

qt.connect(qt.QtLuaListener(widget.N),
            'sigMousePress(int,int,QByteArray,QByteArray,QByteArray)',
            function (...)
                if imgcnt<#t then
                    imgcnt = imgcnt +1
                else
                    imgcnt = 1    
                end   
            end)

qt.connect(qt.QtLuaListener(widget.P),
            'sigMousePress(int,int,QByteArray,QByteArray,QByteArray)',
            function (...)
                if imgcnt > 1  then
                    imgcnt = imgcnt - 1
                else
                    imgcnt = #t 
                end
            end)

-- setup gui
local timer = qt.QTimer()
timer.interval = 100
timer.singleShot = true
qt.connect(timer,
            'timeout()',
            function()
                process()
                display()
                timer:start()
            end)
widget.windowTitle = 'A Simple Frame Grabber'
widget:show()
timer:start()
